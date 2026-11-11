# DuoLab

An open-source iOS app for developers learning **iPhone Duo** (Apple's folding iPhone, iOS 27.1). It has four parts: interactive demos of the Duo APIs, a live device inspector, a behavior recorder, and **Ask DuoLab**, a search box backed by Apple's FoundationModels that answers from the app's own notes.

The repo is public. Write everything (code, comments, docs, commit messages) for a learner who will read it.

## Where to look

| Doc | What it holds |
|---|---|
| [docs/PRODUCT.md](docs/PRODUCT.md) | Audience, v1 features, acceptance criteria, non-goals |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Layers, folders, data flow, device-state bridge, recorder, testing |
| [docs/AI.md](docs/AI.md) | Ask DuoLab: models, routing, retrieval, tools, guardrails, evals |
| [docs/DUO_APIS.md](docs/DUO_APIS.md) | Every Duo API we cover, its demo, and its verification status |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Phases and the next tasks |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Why things are the way they are. Read before reversing a choice. |

## Toolchain

- Xcode 27.1 or later, iOS 27.1 SDK. Deployment target is iOS 27.1, iPhone only.
- Swift 6 language mode, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, approachable concurrency on.
- File-system synchronized groups: adding a file under `DuoLab/` adds it to the target. Don't hand-edit `project.pbxproj` to add files.
- No third-party dependencies. Apple frameworks only (see D9 in DECISIONS).

## Commands

```bash
# Build for the iPhone Duo simulator
xcodebuild -project DuoLab.xcodeproj -scheme DuoLab -destination 'platform=iOS Simulator,name=iPhone Duo' build

# Run tests (once the DuoLabTests target exists, see ROADMAP phase 0)
xcodebuild -project DuoLab.xcodeproj -scheme DuoLab -destination 'platform=iOS Simulator,name=iPhone Duo' test

# Check that API names exist in the installed SDK
scripts/verify-sdk-symbols.sh                  # everything in scripts/sdk-symbols.txt
scripts/verify-sdk-symbols.sh onHingeChange    # specific names
```

Also build against a regular iPhone simulator (for example `iPhone 18 Pro`) when touching anything that must degrade on non-Duo devices.

## Rules

### Never trust a remembered Duo API name
The Duo SDK shipped in October 2026, and web articles about it disagree with each other and with the SDK. Before writing any Duo or FoundationModels symbol in code, notes or docs:
1. Run `scripts/verify-sdk-symbols.sh <name>`, or grep the `.swiftinterface` / header in `$(xcrun --sdk iphoneos --show-sdk-path)`.
2. Add the name to `scripts/sdk-symbols.txt` if it is new.
If a name isn't in the SDK, don't use it. Say so instead of guessing.

### Runtime capability, not `#available`
The deployment target is already 27.1, so the Duo APIs always compile. What varies is the hardware: `DeviceHingeContext.hinge` is `nil` on phones without a hinge, the inner/outer ultra-wide cameras don't exist there, and reserved regions may be empty. Check the capability at runtime and show the "Duo only" explainer when it's missing. Never crash or show a blank screen on a regular iPhone.

### Every demo is four pieces
When adding or changing a demo, update all four in the same change:
1. Views in `DuoLab/Features/Demos/<DemoName>/`.
2. A `DemoID` case and `DemoEntry` in `DuoLab/Core/Catalog/`.
3. A note in `DuoLab/Resources/Notes/<note-id>.md`, where the note ID is the demo ID in kebab-case (`reservedRegions` → `reserved-regions.md`). The format is in ARCHITECTURE.
4. Its row in `docs/DUO_APIS.md`, with an honest verification status.

### Verification status is a promise
Status labels are in `docs/DUO_APIS.md`. Nobody on the project has a physical iPhone Duo yet. Never mark anything **device-verified** unless someone reported testing it on a real Duo (link the issue). A build that compiles is not verified.

### Notes are in our own words
Notes in `Resources/Notes/` are what Ask DuoLab answers from, and the repo is public. Write explanations yourself and link to developer.apple.com. Don't paste Apple documentation text or WWDC transcripts.

### Ask DuoLab boundaries
- The model answers only from tool results (DuoLab notes, demo catalog, live device state). No general chat, no code generation.
- Private Cloud Compute is used only when the user has turned on the Settings toggle. Every answer shows which model produced it.
- No network calls anywhere else in the app. No analytics. Recordings never leave the device unless the user exports them.
- Details and the prompt live in `docs/AI.md`. Change the doc when you change the behavior.

### Code style
- SwiftUI first. Use UIKit only when a demo is about a UIKit API or SwiftUI has no equivalent. Duo demos that have both a SwiftUI and a UIKit API show SwiftUI first and link the UIKit name.
- `@Observable` models injected with `.environment`. No singletons except the composition root in `DuoLabApp`.
- Features depend on `Core`. Features never import each other; cross-feature navigation goes through `AppRouter`.
- Keep demo code readable over clever: it is teaching material. Short comments that explain *why* a Duo behavior happens are welcome.
- All user-facing strings go through the String Catalog (`LOCALIZATION_PREFERS_STRING_CATALOGS` is on). English only for now.

### Project hygiene
- Never commit `xcuserdata/` or `*.xcuserstate` (they're in `.gitignore`).
- Keep `PRODUCT_BUNDLE_IDENTIFIER` as the `devplaceholder…` value and leave `DEVELOPMENT_TEAM` unset. Each learner sets their own signing locally.
- There is no LICENSE yet (D7). Don't add one without the owner's say.
- Update `docs/ARCHITECTURE.md` when structure changes, and add an entry to `docs/DECISIONS.md` when a decision changes.
