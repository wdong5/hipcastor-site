#!/bin/bash
set -euo pipefail

# Resize and compress images in the site's images/ directory using macOS sips.
# Operates in-place -- use git to revert if needed.
#
# Usage:
#   ./scripts/optimize-images.sh              # run for real
#   ./scripts/optimize-images.sh --dry-run    # preview changes without modifying files

IMAGES_DIR="$(cd "$(dirname "$0")/../images" && pwd)"
DRY_RUN=false
TOTAL_BEFORE=0
TOTAL_AFTER=0
SKIPPED=0
PROCESSED=0

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    printf "=== DRY RUN — no files will be modified ===\n\n"
fi

# Files to skip (site branding, already small)
SKIP_FILES=(
    "logo.jpg"
    "oregon.png"
    "favicon.ico"
    "bio-photo.jpg"
    "dummy.png"
)

should_skip() {
    local filename
    filename="$(basename "$1")"
    for skip in "${SKIP_FILES[@]}"; do
        if [[ "$filename" == "$skip" ]]; then
            return 0
        fi
    done
    return 1
}

get_target_width() {
    local filepath="$1"
    local rel
    rel="${filepath#"$IMAGES_DIR"/}"
    local subdir="${rel%%/*}"

    case "$subdir" in
        teampic)
            # Team portraits: displayed at ~25% of container
            # Group photos in teampic/ are wider — detect by filename
            case "$(basename "$filepath")" in
                chipross-*|group-*|fthoskins-*|sc25.*)
                    echo 1200
                    ;;
                *)
                    echo 400
                    ;;
            esac
            ;;
        corv)
            echo 1200
            ;;
        pubpic|logopic)
            echo 800
            ;;
        *)
            # Root-level images and anything else
            echo 1200
            ;;
    esac
}

format_bytes() {
    local bytes=$1
    if (( bytes >= 1048576 )); then
        printf "%.1fMB" "$(echo "scale=1; $bytes / 1048576" | bc)"
    else
        printf "%.0fKB" "$(echo "scale=0; $bytes / 1024" | bc)"
    fi
}

process_image() {
    local filepath="$1"
    local filename
    filename="$(basename "$filepath")"
    local ext="${filename##*.}"
    ext="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"

    if should_skip "$filepath"; then
        return
    fi

    # Only process raster image formats
    case "$ext" in
        jpg|jpeg|png) ;;
        *) return ;;
    esac

    local target_width
    target_width="$(get_target_width "$filepath")"

    local current_width
    current_width="$(sips -g pixelWidth "$filepath" 2>/dev/null | awk '/pixelWidth/{print $2}')"

    if [[ -z "$current_width" ]]; then
        printf "  SKIP (unreadable): %s\n" "$filepath"
        return
    fi

    local before_size
    before_size="$(stat -f%z "$filepath")"
    TOTAL_BEFORE=$((TOTAL_BEFORE + before_size))

    if (( current_width <= target_width )); then
        TOTAL_AFTER=$((TOTAL_AFTER + before_size))
        SKIPPED=$((SKIPPED + 1))
        return
    fi

    local rel
    rel="${filepath#"$IMAGES_DIR"/}"

    if $DRY_RUN; then
        printf "  RESIZE: %-45s %5spx -> %spx  (%s)\n" \
            "$rel" "$current_width" "$target_width" "$(format_bytes "$before_size")"
        TOTAL_AFTER=$((TOTAL_AFTER + before_size / 2))  # rough estimate
        PROCESSED=$((PROCESSED + 1))
        return
    fi

    # Resize to target width, maintaining aspect ratio
    sips --resampleWidth "$target_width" "$filepath" >/dev/null 2>&1

    # For JPEGs, also set compression quality
    if [[ "$ext" == "jpg" || "$ext" == "jpeg" ]]; then
        sips -s formatOptions 85 "$filepath" >/dev/null 2>&1
    fi

    local after_size
    after_size="$(stat -f%z "$filepath")"
    TOTAL_AFTER=$((TOTAL_AFTER + after_size))
    PROCESSED=$((PROCESSED + 1))

    local saved=$((before_size - after_size))
    local pct=0
    if (( before_size > 0 )); then
        pct=$((saved * 100 / before_size))
    fi

    printf "  RESIZE: %-45s %5spx -> %spx  %s -> %s  (-%d%%)\n" \
        "$rel" "$current_width" "$target_width" \
        "$(format_bytes "$before_size")" "$(format_bytes "$after_size")" "$pct"
}

# Convert large PNGs without transparency to JPEG
convert_png_to_jpeg() {
    local filepath="$1"
    local filename
    filename="$(basename "$filepath")"
    local ext="${filename##*.}"
    ext="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"

    if [[ "$ext" != "png" ]]; then
        return
    fi

    if should_skip "$filepath"; then
        return
    fi

    local filesize
    filesize="$(stat -f%z "$filepath")"

    # Only convert PNGs larger than 500KB
    if (( filesize < 512000 )); then
        return
    fi

    # Check if image has alpha channel
    local has_alpha
    has_alpha="$(sips -g hasAlpha "$filepath" 2>/dev/null | awk '/hasAlpha/{print $2}')"

    if [[ "$has_alpha" == "yes" ]]; then
        return
    fi

    local rel
    rel="${filepath#"$IMAGES_DIR"/}"
    local jpeg_path="${filepath%.png}.jpg"
    if $DRY_RUN; then
        printf "  CONVERT: %-44s PNG -> JPEG  (%s)\n" "$rel" "$(format_bytes "$filesize")"
        return
    fi

    sips -s format jpeg -s formatOptions 85 "$filepath" --out "$jpeg_path" >/dev/null 2>&1

    local jpeg_size
    jpeg_size="$(stat -f%z "$jpeg_path")"
    local pct=$((( filesize - jpeg_size ) * 100 / filesize))

    printf "  CONVERT: %-44s PNG(%s) -> JPEG(%s)  (-%d%%)\n" \
        "$rel" "$(format_bytes "$filesize")" "$(format_bytes "$jpeg_size")" "$pct"

    # Remove original PNG, keep the JPEG
    trash "$filepath"

    printf "    NOTE: Template references to '%s' must be updated to '%s'\n" \
        "$filename" "$(basename "$jpeg_path")"
}

printf "Scanning %s ...\n\n" "$IMAGES_DIR"

# Pass 1: Convert large opaque PNGs to JPEG
printf '%s\n' "--- PNG to JPEG conversions (>500KB, no transparency) ---"
while IFS= read -r -d '' img; do
    convert_png_to_jpeg "$img"
done < <(find "$IMAGES_DIR" -type f -iname '*.png' -print0)
printf "\n"

# Pass 2: Resize all images
printf '%s\n' "--- Resizing images ---"
while IFS= read -r -d '' img; do
    process_image "$img"
done < <(find "$IMAGES_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0)

printf '\n%s\n' "--- Summary ---"
printf "  Processed: %d files\n" "$PROCESSED"
printf "  Skipped (already small enough): %d files\n" "$SKIPPED"

if $DRY_RUN; then
    printf "  Estimated total before: %s\n" "$(format_bytes "$TOTAL_BEFORE")"
    printf "  (Run without --dry-run to see actual savings)\n"
else
    local_saved=$((TOTAL_BEFORE - TOTAL_AFTER))
    if (( TOTAL_BEFORE > 0 )); then
        local_pct=$((local_saved * 100 / TOTAL_BEFORE))
    else
        local_pct=0
    fi
    printf "  Total before: %s\n" "$(format_bytes "$TOTAL_BEFORE")"
    printf "  Total after:  %s\n" "$(format_bytes "$TOTAL_AFTER")"
    printf "  Saved:        %s (-%d%%)\n" "$(format_bytes "$local_saved")" "$local_pct"
fi
