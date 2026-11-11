# DuoLab

A hands-on lab for learning **iPhone Duo** development. Fold the phone and watch the APIs react, read the code behind each behavior, and ask questions answered by an on-device model.

> **Status: early.** The specs are written and the project builds; the features below are being built in the order in [docs/ROADMAP.md](docs/ROADMAP.md).

## What's inside

| | |
|---|---|
| **Explore** | Interactive demos of the iPhone Duo APIs: hinge updates, arrangement views, reserved regions, vertical toolbars, sheet placement, and the two front cameras. Each demo shows its code and the exact API names. |
| **Inspect** | A live dashboard of the device: hinge angle and status, which display you're on, size classes, reserved regions drawn on screen. |
| **Record** | Record what changes while you fold, unfold and rotate, then review the timeline or export it as JSON or CSV. |
| **Ask DuoLab** | Ask a question and get a short answer from DuoLab's notes, with citations and a button to the matching demo. Runs on Apple's on-device model; Private Cloud Compute is opt-in. |

## Requirements

- A Mac with **Xcode 27.1** or later (the iPhone Duo SDK ships with it)
- iOS **27.1** or later: the **iPhone Duo simulator**, a regular iPhone, or an iPhone Duo
- For Ask DuoLab: Apple Intelligence turned on (on the device, or on the Mac when using the simulator). Without it, Ask falls back to keyword search.

DuoLab runs on any iPhone with iOS 27.1. Duo-only demos explain what they would show and suggest the iPhone Duo simulator.

## Getting started

1. Clone this repository and open `DuoLab.xcodeproj`.
2. Pick the **DuoLab** scheme and the **iPhone Duo** simulator.
3. Run (⌘R).

To run on your own iPhone, select your team under *Signing & Capabilities* and change the bundle identifier to one of yours. Please don't commit those changes.

From the command line:

```bash
xcodebuild -project DuoLab.xcodeproj -scheme DuoLab -destination 'platform=iOS Simulator,name=iPhone Duo' build
```

## Is it verified?

The Duo APIs are new and nobody on this project has a physical iPhone Duo yet. Every API in [docs/DUO_APIS.md](docs/DUO_APIS.md) carries a label: **Planned**, **Built**, **Simulator** (checked in the iPhone Duo simulator) or **Device** (checked on real hardware, with a linked report).

If you own an iPhone Duo, a test report in [Issues](../../issues) using the checklist in DUO_APIS.md is the most helpful thing you can send.

## Privacy

- Everything runs on your device. No accounts, no analytics.
- Ask DuoLab uses Apple's on-device model by default. If you turn on **Allow Private Cloud Compute** in Settings, your question and the notes it retrieved can be sent to Apple's Private Cloud Compute. It's off by default.
- Recordings stay on your device unless you export them.

## Docs

| Doc | For |
|---|---|
| [docs/PRODUCT.md](docs/PRODUCT.md) | What DuoLab does and doesn't do |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | How the app is put together |
| [docs/AI.md](docs/AI.md) | How Ask DuoLab works |
| [docs/DUO_APIS.md](docs/DUO_APIS.md) | Every Duo API covered, and its verification status |
| [docs/ROADMAP.md](docs/ROADMAP.md) | What's next |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Why things are the way they are |
| [CLAUDE.md](CLAUDE.md) | Instructions for AI coding agents working in this repo |

## Feedback

Bug reports, questions and device test results are welcome in [Issues](../../issues). Pull requests aren't being accepted yet.

## License

Not chosen yet. Until a license is added, all rights are reserved.

---

DuoLab is an independent learning project, not affiliated with or endorsed by Apple Inc. iPhone and Apple Intelligence are trademarks of Apple Inc.
