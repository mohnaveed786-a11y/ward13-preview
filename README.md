# Ward 13 — Browser testing setup

This repository contains **the real Godot Room 101 Environment V2** preview, not a screenshot or imitation HTML game.

## One-time setup

1. Create a new GitHub repository named `ward13-preview` (public is simplest for GitHub Pages), and upload **the contents of this folder** to the repository root; keep the `.github` folder.
2. Under repository **Settings → Pages**, set **Build and deployment → Source: GitHub Actions**.
3. Open the repository **Actions** tab and run **Ward 13 Web Preview** via **Run workflow** (or push a commit to `main`).
4. After the build/deploy job succeeds, open the URL shown in the `deploy` job or Settings → Pages. Typically it is `https://USERNAME.github.io/ward13-preview/` (replace USERNAME with your actual GitHub username).
5. Click inside the preview for mouse look, WASD to move, Shift to sprint, and Esc to unlock cursor.

## Subsequent updates

Only replace files inside `game/`, commit changes to `main`, and the same preview site rebuilds automatically. No ZIP downloads or local Godot imports needed for reviewing updates. The web build is a **testing target**, not the Google Play / Android build.

## Technical notes

- Godot 4.3; Compatibility/WebGL 2.0 rendering; `Web` export with threading disabled to work on ordinary static hosting.
- GitHub Actions uses the Godot CI 4.3 Docker image to import GLB assets and export WebAssembly/HTML.
- Export templates are provided by that image (not bundled here).
- Avoid real credentials or private assets in the repo: any public preview can be downloaded by visitors.
- If the build fails, check the Actions logs. If a web browser reports WebGL 2 is unavailable, test in up-to-date Chrome or Firefox with hardware acceleration enabled.
- Mouse capture only works after interacting with the page, and can be limited in embedded previews.
- The supplied scene has not been built in Godot in this environment, so automated deployment and WebGL rendering are unverified until the first GitHub Actions run.

## Included

- `game/project.godot` and full Room 101 Godot source.
- `game/assets/ward13_room101_v2.glb` textured interactive environment.
- `game/export_presets.cfg` Web export preset.
- `.github/workflows/deploy-preview.yml` GitHub Pages automatic build and publish.
