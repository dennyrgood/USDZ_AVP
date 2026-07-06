# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A GitHub Pages site that hosts `.usdz` 3D model files (AR Quick Look / Apple Vision Pro compatible assets) alongside PNG thumbnails, plus a small visionOS/iOS/macOS test app (`TestUDSZavp_app`) used to preview a couple of those USDZ assets in a RealityKit scene.

## Common commands

- **Regenerate thumbnails, index, and deploy (full pipeline)**: `./refresh.swift`
  - Requires macOS with Xcode/Swift installed (uses SceneKit + Model I/O to render each `.usdz` to a 512x512 PNG).
  - Skips regenerating a thumbnail if the existing `.png` is newer than its `.usdz`.
  - Errors from thumbnail generation are logged to `refresh.log`.
  - After generating thumbnails it automatically runs `generate_index_with_USDZ.sh` then `deploy.sh`.
- **Regenerate index.html only**: `./generate_index_with_USDZ.sh` — scans the current directory for `*.usdz` files and writes `index.html` (Tailwind-CDN-styled download list, pairing each `<file>.usdz` with a `<file>.png` thumbnail if present). Also ensures a `.nojekyll` file exists for GitHub Pages.
- **Commit and push (deploy)**: `./deploy.sh` — runs `git add .`, commits with message "Updated content" (exits early if nothing staged), and `git push origin main`.
- **Filter a file listing down to non-asset files**: `./filter_files.py` (or `.pl`) — reads filenames from stdin/args and prints only lines NOT ending in `.usdz`/`.png`; used for auditing what's in the repo besides 3D assets.
- Older scripts (`usdz_thumbnailer.swift`, `usdz_thumbnailer`, `generate_usdz_thumbnails.sh`) are obsolete and were removed; `refresh.swift.bkp`/`refresh.swift.bkp2` are backups, not active.

### TestUDSZavp_app (Swift package)

- Swift Package Manager project targeting `.visionOS(.v2)`, `.macOS(.v15)`, `.iOS(.v18)` (swift-tools-version 6.0).
- Build/open with Xcode (open `TestUDSZavp_app/Package.swift`); no CLI test target is defined.
- `Sources/TestUDSZavp/TestUDSZavp.swift` currently only exposes `testUDSZavpBundle` (`Bundle.module`) — it's a minimal library target, not yet a full app entry point.
- `Sources/TestUDSZavp/TestUDSZavp.rkassets/` is a Reality Composer Pro asset package (`Package.realitycomposerpro/`) containing `Scene.usda`, `Ground.usda`, `SceneTestWallMountPump.usda`, and copies of `pump.usdz`/`pump000.usdz` used to test placing/wall-mounting a model in a RealityKit scene.

## High-level architecture

- **Top-level directory** is the published GitHub Pages site: pairs of `<name>.usdz` + `<name>.png` (3D model + its thumbnail image), plus generated `index.html` (and near-duplicate variants `index_usdz.html`, `index_simple.html`, `index_editors.html` from earlier iterations of the generator).
- **Pipeline flow**: `refresh.swift` (thumbnail generation, via SceneKit/ModelIO) → `generate_index_with_USDZ.sh` (rebuilds `index.html` from whatever `*.usdz`/`*.png` pairs exist) → `deploy.sh` (git commit + push to `main`, which GitHub Pages serves from).
- **`TestUDSZavp_app/`** is a separate, only loosely-related Swift package: a sandbox for testing how a USDZ model (e.g. `pump.usdz`) behaves as a Reality Composer Pro scene/asset for visionOS, independent of the static site pipeline above.
- **`Doc/`** contains historical documentation (Word/PDF docs and their generated Markdown in `Doc/md_outputs/`) describing the refresh/index/deploy scripts and a `HISTORY.txt` shell history log — useful for archaeology on why scripts evolved, but not authoritative over the current script contents.
