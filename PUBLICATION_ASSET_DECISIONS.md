# Publication asset decisions

This ledger records which non-code assets Cosmos ships and where their
provenance is documented.

## Project branding

All Cosmos branding is original to this project and covered by the
repository license.

| Asset | Purpose |
|---|---|
| `assets/branding/cosmos-mark.svg` | Vector mark used in the README |
| `assets/branding/cosmos.png` | 1024px mark; source for the macOS app icon (`build-macos-app.sh`) |
| `static/icons/icon-192.png`, `static/icons/icon-512.png` | PWA icons (`any maskable`), mark inside the 80% safe zone |
| `static/icons/icon-maskable-512.png` | PWA maskable icon |
| `static/icon.ico` | Multi-size favicon (16–256px) |

The inline SVG favicons in `static/index.html`, `static/login.html`,
`website/index.html` and `static/js/theme.js` draw the same mark: a planet,
an orbit ring at 60% opacity, and a moon on that ring, on a 32-unit grid.
The current mark is a placeholder and is expected to be replaced by a
designed logo.

## Media

Cosmos ships no demo or tutorial videos. The landing page describes each
feature in text.

## Omitted third-party resources

These third-party files are deliberately not shipped. They must not be
re-added, and nothing outside this ledger and its test may reference them
(enforced by `tests/test_publication_plan_b.py`):

- `static/lib/html2pdf.bundle.min.js` (PDF export uses the browser's Print / save PDF)
- `static/lib/qrcode.min.js` (2FA QR codes are generated server-side)
- `static/fonts/custom/GohuFont.ttf` (saved `gohu` font preferences map to `mono`)
- `static/icons/ollama-mark.png`
- `static/icons/ollama-mark-crop.png`
- `static/icons/sglang-mark.png`
- `static/icons/sglang-logo.png`

## Third-party assets

Bundled third-party libraries, fonts and their notices are tracked in
[THIRD_PARTY_PROVENANCE.json](THIRD_PARTY_PROVENANCE.json), with license texts
in [`licenses/`](licenses/) and credits in
[ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md). Vendor marks (model-provider and
serving-engine logos) are not bundled.
