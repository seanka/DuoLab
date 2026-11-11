# DuoLab product spec

Status: draft v1 · Last updated: 2026-11-11

## Why

iPhone Duo shipped on 23 October 2026 with iOS 27.1. It brings things no iPhone had before: a hinge, an inner display that behaves like an iPad (regular width and height), an outer display that behaves like an iPhone, toolbars that can move to a vertical edge, and a front camera on each display. The APIs that go with it (arrangement views, reserved regions, hinge updates, scene accessories, new camera device types) are new, thinly documented, and described inconsistently online.

DuoLab is a place to **see each API working on the device, read the code next to it, and ask questions** without leaving the app.

## Who it's for

**iOS developers learning iPhone Duo.** They know Swift and SwiftUI. They want to know what an API does on the real hardware, what the code looks like, and what the gotchas are.

They are not necessarily Duo owners. Many will run DuoLab in the iPhone Duo simulator or on a regular iPhone, so the app must be useful there too and clear about what it can't show.

## Principles

1. **Show the real behavior.** Every demo reacts live to the device: fold it, rotate it, switch displays, and see what changes.
2. **Code next to behavior.** Each demo shows the key code and names the exact API symbols, checked against the SDK.
3. **Honest about verification.** Each demo carries a verification label (see [DUO_APIS.md](DUO_APIS.md)). We never claim we tested on hardware we don't have.
4. **Private by default.** Everything runs on the device. Private Cloud Compute is opt-in, and there are no analytics.
5. **Works on any iPhone on iOS 27.1+.** Duo-only features explain themselves on other phones instead of breaking.

## v1 features

### 1. Explore: API demo catalog

A list of demos grouped by topic (Layout, Hinge, Bars & presentation, Cameras). On the inner display it becomes a sidebar-and-detail layout, so the app demonstrates the APIs it teaches.

Each demo screen has:
- **Live demo**: an interactive view using the API.
- **Code**: the minimal code for that demo, with symbol names.
- **Notes**: what it is, how it behaves, gotchas, and a link to Apple's docs.
- **Badges**: frameworks, "Duo only", and verification status.

Acceptance criteria:
- Every demo listed in [DUO_APIS.md](DUO_APIS.md) as built opens without crashing on both the iPhone Duo simulator and a regular iPhone simulator.
- On a non-Duo device, Duo-only demos show an explainer card ("This needs iPhone Duo. Try the iPhone Duo simulator.") instead of an empty view.
- Every symbol named on a demo screen passes `scripts/verify-sdk-symbols.sh`.

### 2. Inspect: live device inspector

A dashboard of what the device is doing right now:
- Hinge status and angle (or "no hinge").
- Which display DuoLab thinks it's on (outer / inner), labeled as **inferred**, because the SDK has no direct API for it (see ARCHITECTURE).
- Window size, horizontal and vertical size classes, interface orientation.
- Reserved regions (division and occlusion), listed and drawn as an overlay on the screen, including inactive ones.
- Where the vertical toolbar edge is, if any.

Acceptance criteria:
- Values update within one frame of the change on the simulator (no polling).
- The overlay can be toggled and doesn't block touches.
- Every value says where it came from (the API name), so learners can map what they see to code.

### 3. Record: behavior recorder

Record a timeline of device-state changes while you fold, unfold, rotate or switch displays, then review or export it.

- Start/stop recording; add a text marker at any moment ("now in tent posture").
- Timeline view: each event with a timestamp and what changed.
- Export through the share sheet as JSON (full fidelity) or CSV (one row per event).
- Recordings are stored on the device only.

Acceptance criteria:
- Hinge angle events are throttled so a 30-second fold produces a readable timeline, not thousands of rows (rule in ARCHITECTURE).
- An exported JSON file can be decoded back into the same recording (round-trip test).
- Deleting a recording removes its file.

### 4. Ask DuoLab: on-device AI search

A search box. Type a question ("how do I know if the phone is folded?") and get a short answer based on DuoLab's notes, with:
- **Citations** to the notes it used (tap to open).
- **Suggested demo** buttons that jump to the matching demo.
- **Live context**: questions like "what's the hinge angle right now?" use the current device state.
- **Model badge**: On-device, Private Cloud, or Keyword search.

Model rules (full detail in [AI.md](AI.md)):
- On-device model (`SystemLanguageModel`) by default.
- Private Cloud Compute (`PrivateCloudComputeLanguageModel`) only when the user turns on **Settings → Allow Private Cloud Compute**. The quota and its reset date are shown in Settings.
- When no model is available (Apple Intelligence off, ineligible device, model downloading), Ask falls back to keyword search over the same notes and says why.

Acceptance criteria:
- Answers cite at least one note, or say DuoLab has no note on the topic. No uncited answers.
- Any API name in an answer that isn't in DuoLab's known-symbol list is flagged in the UI as unverified.
- Passes the eval set in [AI.md](AI.md) at the bar set there.
- With Private Cloud off, the app makes no network requests.

### Settings

- Allow Private Cloud Compute (off by default), with a plain explanation of what is sent.
- Apple Intelligence status (on-device model availability and the reason if unavailable).
- Recorder: angle threshold for hinge events.
- About: version, link to the GitHub repo and issues, the "not affiliated with Apple" note.

## Non-goals for v1

- **No code generation.** A small model invents API names; we would be teaching mistakes.
- **No general chatbot.** Ask DuoLab only answers about Duo, its APIs, and the current device state.
- **No iPad layout.** The arrangement APIs exist on iPadOS 27.1, but v1 is iPhone only.
- **No App Store or TestFlight release.** Learners build it from source.
- **No accounts, sync, analytics or network** (other than opt-in Private Cloud Compute).
- **No bundled third-party model.**
- **No localization yet.** Strings go through the String Catalog so it can be added later.

## Open questions

| # | Question | Blocks |
|---|---|---|
| Q1 | Can the iPhone Duo simulator change hinge angle and posture, and which reserved regions does it report? | Inspector and hinge demo verification |
| Q2 | Does `SpotlightSearchTool` work over an app's own private Core Spotlight index well enough, or do we need our own search tool? | Ask DuoLab retrieval (spike in ROADMAP phase 4) |
| Q3 | License for the public repo. | Public announcement (D7) |
| Q4 | How Duo owners report device test results while the repo takes issues only (an issue template?). | Device verification |
