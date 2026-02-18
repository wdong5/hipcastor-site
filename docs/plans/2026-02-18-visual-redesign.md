# Visual Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Upgrade the HiPCastor site with modern typography, OSU-orange bordered cards, and
scroll-reveal animations across the publications, team, and home pages.

**Architecture:** All styling lives in `css/main.scss` (compiled to `css/main.css` by Jekyll).
The scroll-reveal animation uses a small vanilla `IntersectionObserver` script injected into
`_includes/footer.html`. The home page layout is restructured from a two-column side-by-side
to a single-column vertical stack in `_layouts/homelay.html`. No new dependencies.

**Tech Stack:** Jekyll (static site), Bootstrap 5.3.3 (CDN), SCSS compiled by Jekyll,
Google Fonts (CDN), vanilla JS IntersectionObserver

**OSU orange:** `#d74009` — already defined as `--osu-orange` in `css/main.scss`

**To build and preview:** `bundle exec jekyll serve` then open `http://localhost:4000`

---

### Task 1: Update Google Fonts to Inter + Plus Jakarta Sans + JetBrains Mono

**Files:**
- Modify: `_includes/head.html`

**Step 1: Replace the Google Fonts link**

In `_includes/head.html`, find the existing `<link>` for `Source+Sans+3`:

```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Sans+3:ital,wght@0,300;0,400;0,700;1,400&display=swap">
```

Replace it with:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400&family=JetBrains+Mono:wght@400&family=Plus+Jakarta+Sans:wght@600;700&display=swap">
```

Note: The two `rel="preconnect"` lines already exist in `head.html` — do NOT duplicate them.
Only replace the `<link rel="stylesheet" href="https://fonts.googleapis.com/...">` line.

**Step 2: Verify the fonts load**

Run `bundle exec jekyll serve`, open `http://localhost:4000`, open browser DevTools →
Network tab, filter by "fonts.gstatic.com" — you should see requests for Inter, JetBrains
Mono, and Plus Jakarta Sans.

**Step 3: Commit**

```bash
git add _includes/head.html
git commit -m "style: load Inter, Plus Jakarta Sans, JetBrains Mono from Google Fonts"
```

---

### Task 2: Update typography in main.scss

**Files:**
- Modify: `css/main.scss`

**Step 1: Update body font**

Find:
```css
body {
  font-family: "Source Sans 3", "Helvetica Neue", Helvetica, Arial, sans-serif;
}
```

Replace with:
```css
body {
  font-family: "Inter", "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-weight: 400;
}
```

**Step 2: Add heading font rules**

After the `body` font-family block (after the closing `}`) and before the `html` block, add:

```css
h1, h2, h3, h4, h5, h6 {
  font-family: "Plus Jakarta Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-weight: 700;
}
```

**Step 3: Update kbd to use JetBrains Mono with OSU orange**

Find the `kbd,` block (starts around line 114):
```css
kbd,
.kbd {
  margin: 0 0.1em;
  padding: 0.1em 0.3em;
  border-radius: 3px;
  border: 2px solid rgb(0, 0, 0);
  background-color: #f0ccc0;
  color: #000;
  line-height: 1.1;
  font-family: "Lucida Grande", Lucida, Verdana, sans-serif;
  font-size: 14px;
  display: inline-block;
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.2), inset 0 0 0 1px #ffffff;
}
```

Replace with:
```css
kbd,
.kbd {
  margin: 0 0.1em;
  padding: 0.15em 0.5em;
  border-radius: 4px;
  border: 1.5px solid rgba(215, 64, 9, 0.40);
  background-color: rgba(215, 64, 9, 0.06);
  color: var(--osu-orange);
  line-height: 1.2;
  font-family: "JetBrains Mono", "Lucida Console", monospace;
  font-size: 13px;
  display: inline-block;
  box-shadow: none;
  font-weight: 400;
}
```

**Step 4: Verify in browser**

`bundle exec jekyll serve` → check the Publications page (`/publications/`). Headings should
use Plus Jakarta Sans, body text Inter, venue `<kbd>` badges should appear in muted orange.

**Step 5: Commit**

```bash
git add css/main.scss
git commit -m "style: apply Inter/Plus Jakarta Sans/JetBrains Mono typography"
```

---

### Task 3: Add `.hpc-card` CSS class

**Files:**
- Modify: `css/main.scss`

**Step 1: Add the card block at the end of main.scss**

Append the following after the last existing rule (after the `kbd` block, at end of file):

```scss
/* =====================================================
   HPC Cards — OSU orange bordered, scroll-reveal
   ===================================================== */

.hpc-card {
  border: 1.5px solid rgba(215, 64, 9, 0.30);
  border-radius: 10px;
  padding: 1.5rem;
  background: #fff;
  margin-bottom: 1.25rem;

  /* scroll-reveal: start hidden */
  opacity: 0;
  transform: translateY(20px);

  /* all transitions combined */
  transition:
    opacity 0.45s ease,
    transform 0.45s ease,
    box-shadow 0.22s ease,
    border-color 0.22s ease;
}

/* revealed by IntersectionObserver */
.hpc-card.revealed {
  opacity: 1;
  transform: translateY(0);
}

/* stagger siblings so they don't all appear at once */
.hpc-card:nth-child(2) { transition-delay: 80ms; }
.hpc-card:nth-child(3) { transition-delay: 160ms; }
.hpc-card:nth-child(4) { transition-delay: 240ms; }

/* hover lift — only after revealed so it doesn't fight the initial animation */
.hpc-card.revealed:hover {
  transform: translateY(-4px);
  border-color: var(--osu-orange);
  box-shadow: 0 6px 20px rgba(215, 64, 9, 0.15);
}
```

**Step 2: Commit (CSS only — no visible change until cards are wired up)**

```bash
git add css/main.scss
git commit -m "style: add .hpc-card class with OSU orange border and scroll-reveal"
```

---

### Task 4: Add IntersectionObserver scroll-reveal script

**Files:**
- Modify: `_includes/footer.html`

**Step 1: Add the script before the closing `</footer>` tag**

In `_includes/footer.html`, find the existing closing `</footer>` tag (line 19). Insert
immediately *after* the `</footer>` tag and *before* the Bootstrap `<script>` tag:

```html
<script>
  (function () {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    document.querySelectorAll('.hpc-card').forEach(function (el) {
      observer.observe(el);
    });
  })();
</script>
```

The script is an IIFE (immediately-invoked function expression) — no globals, no libraries.
`threshold: 0.12` means a card reveals when 12% of it enters the viewport.

**Step 2: Verify**

`bundle exec jekyll serve` → with cards not yet on any page, this script is harmless (queries
zero elements). No console errors expected.

**Step 3: Commit**

```bash
git add _includes/footer.html
git commit -m "feat: add IntersectionObserver scroll-reveal for .hpc-card elements"
```

---

### Task 5: Apply hpc-card to Publications highlights

**Files:**
- Modify: `_pages/publications.md`

**Step 1: Find the highlighted publication card div**

In `_pages/publications.md`, line 28 reads:
```html
 <div class="card p-3">
```

**Step 2: Add `hpc-card` class**

Replace:
```html
 <div class="card p-3">
```
With:
```html
 <div class="card hpc-card">
```

The `p-3` Bootstrap padding utility is replaced by the `1.5rem` padding built into `.hpc-card`.

**Step 3: Verify in browser**

Navigate to `/publications/`. The highlighted paper cards should:
- Have a subtle orange border at rest
- Lift and glow orange on hover
- Fade in from below when scrolled into view
- The venue `<kbd>` badge should appear in muted orange mono font

**Step 4: Commit**

```bash
git add _pages/publications.md
git commit -m "style: apply hpc-card to highlighted publications"
```

---

### Task 6: Apply hpc-card to Team member blocks

**Files:**
- Modify: `_pages/team.md`

**Step 1: Understand the current structure**

Each team member block looks like:
```html
<div class="col-sm-6 clearfix">
  <img ... />
  <h4>{{ member.name }}</h4>
  <i>{{ member.info }}</i>
  <ul ...>...</ul>
</div>
```

We wrap the *inner content* (not the `col-sm-6`) in an `.hpc-card` div.

**Step 2: Edit every `col-sm-6 clearfix` block in the Members section**

There are four sections in team.md that repeat this pattern: Members, Masters and
Undergraduate Students, Open Source Contributors, Incoming Members, and Alumni.

For *each* occurrence of the `<div class="col-sm-6 clearfix">` block, change it to:

```html
<div class="col-sm-6 clearfix">
  <div class="hpc-card">
  <img ... />
  <h4>{{ member.name }}</h4>
  ...
  </ul>
  </div>
</div>
```

Specifically: insert `  <div class="hpc-card">` immediately after `<div class="col-sm-6 clearfix">`,
and insert `  </div>` immediately before the closing `</div>` of the col block.

Do this for all five sections (Members, Masters/Undergrad, Open Source, Incoming, Alumni).

**Step 3: Remove old row hover rules that conflict**

In `css/main.scss`, find:
```css
#gridid .row { margin-bottom: 24px; transition: transform 0.15s ease, box-shadow 0.15s ease; }
#gridid .row:hover { transform: translateY(-2px); box-shadow: 0 4px 14px rgba(0, 0, 0, 0.10); }
```

Replace with:
```css
#gridid .row { margin-bottom: 24px; }
```

This prevents the old row-level hover from fighting the new card-level hover.

**Step 4: Verify in browser**

Navigate to `/team/`. Each team member should appear as an individual orange-bordered card.
Cards should fade in from below on scroll. On hover, each card lifts individually.

**Step 5: Commit**

```bash
git add _pages/team.md css/main.scss
git commit -m "style: wrap team member blocks in hpc-card"
```

---

### Task 7: Restructure home page to vertical card layout

**Files:**
- Modify: `_layouts/homelay.html`
- Modify: `_includes/news.html`

**Step 1: Rewrite homelay.html**

Current `_layouts/homelay.html`:
```html
---
layout: default
---

  <div id="homeid" class="col-sm-8">
        <h1>Welcome to HiPCastor @ Oregon State University</h1>

	{{ content }}
  </div>
  <div id="newsid" class="col-sm-4" >
	{% include news.html %}
  </div>
```

Replace the entire file content (after the front matter) with:
```html
---
layout: default
---

<div id="homeid" class="col-sm-12">
  <h1>Welcome to HiPCastor @ Oregon State University</h1>

  <div class="hpc-card mb-4">
    {{ content }}
  </div>

  <div id="newsid">
    {% include news.html %}
  </div>
</div>
```

This collapses the two-column layout into a single column. The intro content goes inside an
`.hpc-card`. The news section sits below it and gets its own card (handled in next step).

**Step 2: Update news.html to use hpc-card**

Current `_includes/news.html`:
```html

<div class="card p-3">
<h4>News</h4>

{% for article in site.data.news limit:9 %}
<p>{{ article.date }}<br>{{ article.headline | markdownify}}</p>
{% endfor %}

<h4><a href="{{ site.url }}{{ site.baseurl }}/allnews.html">... see all News</a></h4>

</div>
```

Replace with:
```html
<div class="hpc-card">
  <h4>News</h4>

  {% for article in site.data.news limit:9 %}
  <div class="hpc-card mb-2">
    <p class="mb-1"><strong>{{ article.date }}</strong></p>
    <p class="mb-0">{{ article.headline | markdownify }}</p>
  </div>
  {% endfor %}

  <p class="mt-2 mb-0"><a href="{{ site.url }}{{ site.baseurl }}/allnews.html">... see all News</a></p>
</div>
```

Each news item becomes its own nested `.hpc-card` (smaller, stacked vertically). The outer
card wraps the whole news section.

**Step 3: Remove stale #homeid / #newsid CSS rules that set col widths or floats**

In `css/main.scss`, find and remove or update these rules if they conflict with the new layout:
```css
#homeid img { margin: 0; border-radius: 5%; box-shadow: 0 0 0 #888888; }
```
Keep this rule — it only affects images. Do NOT remove it.

Check that `#newsid p { text-align: left; }` and `#homeidtmp h1 { text-align: center; }`
still make sense — they do, leave them.

**Step 4: Verify in browser**

Navigate to `/` (home). You should see:
- Full-width intro text inside an OSU-orange bordered card
- Below it: a news card with each news item in its own nested card
- All cards fade in from below on load
- Hover effects work on each card

**Step 5: Commit**

```bash
git add _layouts/homelay.html _includes/news.html
git commit -m "style: restructure home to vertical card layout with hpc-card"
```

---

### Task 8: Final visual pass and cleanup

**Step 1: Check all three pages in a browser**

Run `bundle exec jekyll serve`. Check:

| Page | What to verify |
|------|---------------|
| `/` (home) | Intro card + news stack, fonts correct |
| `/publications/` | Highlighted cards have orange borders, kbd badges orange |
| `/team/` | Each member in individual card, scroll-reveal works |

**Step 2: Check mobile**

Resize browser to ~375px width. Cards should stack naturally (Bootstrap grid handles this).

**Step 3: Check scroll-reveal**

Scroll down slowly on the team page (many cards). Cards should fade in as they enter the
viewport, not all at once.

**Step 4: Commit any fixup changes, then done**

```bash
git add -p   # stage only intentional changes
git commit -m "style: visual pass fixups"
```
