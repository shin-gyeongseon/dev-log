# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal digital garden / blog built on [Quartz](https://quartz.jzhao.xyz/) (v5). Markdown notes in `content/` are written in Obsidian or VS Code and built into a static site, deployed to GitHub Pages via GitHub Actions on every push to `main`. See README.md for the full author-facing workflow in Korean.

- Live site: https://shin-gyeongseon.github.io/dev-log/
- `quartz/` is the vendored Quartz engine (build pipeline, components, plugin loader). Treat it as framework code — most tasks should not require editing it.
- `content/` is the actual content (notes/posts). This is where almost all day-to-day work happens.
- `public/` is generated build output — never edit by hand.

## Commands

```bash
# Local dev server with live preview (http://localhost:8080)
npx quartz build --serve

# Type-check + Prettier check (run before committing)
npm run check

# Auto-format with Prettier
npm run format

# Run tests (tsx --test; picks up *.test.ts / *.test.js across quartz/)
npm test

# Run a single test file
npx tsx --test quartz/util/path.test.ts

# Re-install/sync Quartz community plugins declared in quartz.config.yaml
npm run install-plugins

# Full production build (writes to public/)
npx quartz build
```

Node >= 20, npm >= 10 (see `.node-version`, `engines` in package.json).

## Content authoring

- Notes live under `content/<Category>/*.md` (e.g. `content/AI`, `content/Architecture`, `content/DevOps`). Each category folder has an `index.md`.
- Obsidian-flavored syntax is supported: wikilinks (`[[Note]]`, `[[Note|alias]]`), callouts (`> [!NOTE]`), tags (`#tag`), KaTeX math, checklists/tables.
- Paths listed in `ignorePatterns` in `quartz.config.yaml` (currently `private`, `templates`, `.obsidian`) are excluded from the build.
- Pushing to `main` triggers `.github/workflows/deploy.yml`, which runs `npx quartz build` and deploys `public/` to GitHub Pages — no manual deploy step needed.

## Architecture: plugin-driven build

Quartz's build (`quartz/build.ts`, orchestrated via `quartz/cli/handlers.js`) is a pipeline of three processor stages, each populated by plugins declared in `quartz.config.yaml`:

1. **Parse** (`quartz/processors/parse.ts`) — markdown → AST, using `transformers` plugins (frontmatter/note-properties, obsidian/github-flavored markdown, syntax highlighting, latex, crawl-links, description, created-modified-date, etc.)
2. **Filter** (`quartz/processors/filter.ts`) — drops pages via `filters` plugins (e.g. `remove-draft`, `unlisted-pages`, `explicit-publish`)
3. **Emit** (`quartz/processors/emit.ts`) — renders final output via `emitters`/`pageTypes` plugins (content pages, folder pages, tag pages, canvas pages, sitemap/RSS via `content-index`, og-image, favicon, alias-redirects)

Almost all plugins are external `@quartz-community/*` npm packages, not local code — `quartz.config.yaml` is the source of truth for which are enabled, their `order` (execution sequence within a stage), and layout (`position`/`priority` for UI slots like left/right sidebars, beforeBody, footer, toolbar group). To change site behavior, prefer toggling/reconfiguring plugins in `quartz.config.yaml` over touching `quartz/` internals.

Local (non-vendored) code lives in `quartz/components/` (Preact/TSX UI: `Header`, `Body`, `PageList`, etc., registered in `quartz/components/registry.ts`) and `quartz/util/` (path handling, file trie for the explorer, slug collision resolution, theming, i18n). These have their own colocated `*.test.ts` files runnable via `npm test`.

Theme/typography/colors (fonts, light/dark palettes) are configured in `quartz.config.yaml` under `theme`, not in SCSS — `quartz/styles/*.scss` holds structural styles only.
