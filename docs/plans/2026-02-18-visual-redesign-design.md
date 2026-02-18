# Visual Redesign Design — HiPCastor Site

**Date:** 2026-02-18
**Status:** Approved

## Goals

Make the site more visually appealing with modern typography, interactive OSU-orange bordered
cards, and scroll-reveal animations inspired by vllm.ai/contact.

---

## Typography

Replace `Source Sans 3` with a three-font stack loaded from Google Fonts:

| Role     | Font              | Weights    |
|----------|-------------------|------------|
| Headings | Plus Jakarta Sans | 600, 700   |
| Body     | Inter             | 300, 400   |
| Mono     | JetBrains Mono    | 400        |

**CSS rules to update in `css/main.scss`:**
- `body { font-family: "Inter", ... }`
- `h1, h2, h3, h4 { font-family: "Plus Jakarta Sans", ... }`
- `kbd, .kbd { font-family: "JetBrains Mono", ...; color: var(--osu-orange); }`

**`_includes/head.html`:** Replace the single Google Fonts `<link>` with one that loads all
three families.

---

## Cards

### Shared `.hpc-card` class

```css
.hpc-card {
  border: 1.5px solid rgba(215, 64, 9, 0.30);
  border-radius: 10px;
  padding: 1.5rem;
  background: #fff;
  /* scroll-reveal starts hidden */
  opacity: 0;
  transform: translateY(20px);
  transition:
    opacity 0.4s ease,
    transform 0.4s ease,
    box-shadow 0.2s ease,
    border-color 0.2s ease;
}

.hpc-card.revealed {
  opacity: 1;
  transform: translateY(0);
}

.hpc-card:hover {
  transform: translateY(-4px);
  border-color: var(--osu-orange);
  box-shadow: 0 6px 20px rgba(215, 64, 9, 0.15);
}
```

Stagger sibling cards with nth-child delay (0, 80ms, 160ms, 240ms).

### Scroll-reveal script

Small vanilla JS `IntersectionObserver` snippet (no library needed) added to
`_includes/footer.html` (before `</body>`). Observes all `.hpc-card` elements; adds `.revealed`
when they enter the viewport. One-shot (unobserves after reveal).

---

## Per-page changes

### Publications (`_pages/publications.md`)

Highlighted publication blocks already use `.card`. Add `hpc-card` class to each `.card.p-3`
div. No structural changes needed.

### Team (`_pages/team.md`)

Wrap the inner content of each `.col-sm-6` in an `.hpc-card` div. The layout stays as two
columns of cards. The photo floats left inside the card as before.

### Home (`_pages/home.md` + `_layouts/homelay.html` or equivalent)

Two vertical cards replace the current horizontal two-column layout:
1. **Intro card** — the body text paragraph about the group
2. **News card** — the news items from `_includes/news.html`, stacked vertically

Find the home layout file to understand current structure before editing.

---

## Files to change

| File | Change |
|------|--------|
| `_includes/head.html` | Replace Google Fonts link |
| `css/main.scss` | Typography rules + `.hpc-card` + stagger delays |
| `_includes/footer.html` | Add IntersectionObserver script |
| `_pages/publications.md` | Add `hpc-card` class to highlight cards |
| `_pages/team.md` | Wrap team member content in `.hpc-card` |
| `_pages/home.md` or home layout | Restructure to two vertical cards |
