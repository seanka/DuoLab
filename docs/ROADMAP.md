# DuoLab roadmap

Last updated: 2026-11-11

Phases are in build order. Each phase should leave the app runnable on both the iPhone Duo simulator and a regular iPhone simulator. Demos come before Ask DuoLab because Ask answers from the notes the demos produce.

## Phase 0: Foundations

- [x] Rename the `MyApp` folder and app struct to `DuoLab`, target iOS 27.1, Swift 6 language mode (2026-11-11)
- [x] `.gitignore`; stop tracking `xcuserdata/` (2026-11-11)
- [x] Specs: `CLAUDE.md`, `README.md`, `docs/*` (2026-11-11)
- [x] `scripts/verify-sdk-symbols.sh` + `scripts/sdk-symbols.txt` (2026-11-11)
- [ ] Add `DuoLabTests` (Swift Testing) and `DuoLabUITests` targets
- [ ] Folder skeleton: `App/`, `Features/`, `Core/`, `Resources/Notes/`
- [ ] `RootView` with four tabs (Explore, Inspect, Record, Ask) and `AppRouter`; delete the template `ContentView`
- [ ] `DeviceSnapshot`, `DeviceStateMonitor`, `DeviceStateProbe`, `DisplayInference`, with tests for the inference table
- [ ] `DemoID`, `DemoEntry`, `DemoCatalog`, `NoteStore`, with a catalog integrity test

## Phase 1: Inspect, and the first demos

- [ ] Inspector view: every snapshot field, each labeled with the API it came from
- [ ] Reserved region overlay (toggle, doesn't block touches)
- [ ] `hinge` demo (SwiftUI, plus a UIKit tab with `UIHingeInteraction`) and note
- [ ] `reservedRegions` demo and note
- [ ] Topic notes: `device-overview`, `postures`, `size-classes`, `simulator-tips`
- [ ] Answer PRODUCT Q1 (what the Duo simulator can simulate) and fill in "Simulator notes" in DUO_APIS.md

## Phase 2: Layout and bars

- [ ] `arrangement` demo (`ArrangementView`, split ratio and size controls; UIKit tab) and note
- [ ] `verticalBars` demo (vertical behavior, axis behavior, compression, overflow) and note
- [ ] `sheetPlacement` demo and note
- [ ] `backgroundExtension` demo and note
- [ ] Explore becomes a `NavigationSplitView` on the inner display

## Phase 3: Recorder

- [ ] `RecordingSession` with hinge throttling, plus tests
- [ ] `RecordingStore` (JSON files in Application Support), list, detail timeline, markers
- [ ] JSON and CSV export via `ShareLink`, plus a round-trip test

## Phase 4: Ask DuoLab

- [ ] **Spike:** `SpotlightSearchTool` vs our own `SearchNotesTool`, run against the eval set in AI.md; record the result in DECISIONS.md
- [ ] `NotesIndex` (chunking, private Core Spotlight index, re-index on hash change)
- [ ] `ModelRouter` with tests using fake availability
- [ ] `AskService`, `AskAnswer`, streaming UI, model badge, suggested-demo buttons
- [ ] Guardrails: citation check, `SymbolCheck`, error mapping
- [ ] Settings: Private Cloud Compute toggle, on-device availability reason, PCC quota and reset date
- [ ] Keyword search fallback
- [ ] Run the eval set and log results in AI.md

## Phase 5: Cameras

- [ ] Add `INFOPLIST_KEY_NSCameraUsageDescription`
- [ ] `frontCameras` demo (inner/outer ultra-wide device types, `activePrimaryConstituent`, direction coordinator, mirroring) and note
- [ ] `captureAccessory` demo (`CameraCaptureAccessory`) and note
- [ ] These will likely stay 🛠 until a Duo owner reports results

## Phase 6: Going public

- [ ] Decide the license (D7)
- [ ] README screenshots from the iPhone Duo simulator
- [ ] GitHub issue templates: bug report, and a device verification report using the checklist in DUO_APIS.md
- [ ] Revisit the contributions policy (D8)

## Later (not v1)

- Multi-turn follow-ups in Ask DuoLab
- iPad layouts (the arrangement APIs exist on iPadOS 27.1)
- `duolab://demo/<id>` deep links
- Localization
- CI (build both simulators, run tests, run the symbol check)
