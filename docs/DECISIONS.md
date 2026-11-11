# Decisions

Short records of choices that shape DuoLab. Add a new entry instead of editing an old one; mark the old one **Superseded by Dn**.

Format: what we decided, why, and what it rules out.

---

### D1 · Audience: iOS developers learning iPhone Duo
2026-11-11 · Accepted

Every demo shows live behavior, the code behind it, and exact API names. Not aimed at non-developer Duo owners, so no plain-language-only mode.

### D2 · v1 has four parts: demo catalog, inspector, recorder, Ask DuoLab
2026-11-11 · Accepted

The inspector and recorder cover "exploring Duo behaviors"; the catalog covers "exploring new APIs"; Ask DuoLab covers "search and check what you're curious about". Built in that order (ROADMAP), because Ask answers from the notes the demos produce.

### D3 · Any iPhone on iOS 27.1+, iPhone only
2026-11-11 · Accepted

Most learners don't own a Duo, so DuoLab must run on any iPhone and explain Duo-only features instead of hiding them. The deployment target is 27.1 so Duo APIs always compile; capability is checked at runtime (hinge is `nil` without one). iPad is out of scope for v1 even though the arrangement APIs exist on iPadOS 27.1.

### D4 · FoundationModels: on-device by default, Private Cloud Compute opt-in
2026-11-11 · Accepted

`SystemLanguageModel` answers by default. `PrivateCloudComputeLanguageModel` is used only when the user turns on a Settings toggle (off by default); every answer is labeled with its model and Settings shows the PCC quota. Keyword search is the fallback when no model is available. Rules out bundling a third-party model.

### D5 · The model answers from notes, reads device state, suggests demos. It doesn't write code.
2026-11-11 · Accepted

A small model invents API names, and DuoLab's whole job is teaching correct ones. Answers must cite DuoLab notes; unknown API names in answers are flagged.

### D6 · Distributed as open source, built from Xcode
2026-11-11 · Accepted

No App Store or TestFlight for now. The bundle ID stays `devplaceholder…` and `DEVELOPMENT_TEAM` stays unset; each learner signs locally. Revisit if we want an App Store build (needs a real bundle ID, privacy manifest, review notes for the AI feature).

### D7 · License: not decided yet
2026-11-11 · Open

No LICENSE file for now. Until there is one, others can read the code but have no legal right to reuse it. Decide before announcing the repo (ROADMAP phase 6).

### D8 · Issues only, no outside PRs for now
2026-11-11 · Accepted

Personal project at this stage. Feedback and device test reports come in through GitHub Issues. Revisit in phase 6.

### D9 · Apple frameworks only, no third-party dependencies
2026-11-11 · Accepted

Learners should be able to open the project and read everything. Fewer moving parts while the Duo SDK is new.

### D10 · Swift 6, SwiftUI first, main-actor default isolation
2026-11-11 · Accepted

Matches the Xcode 27 template defaults and current Apple sample code. UIKit appears only in demos about UIKit APIs (shown as a "UIKit" tab next to the SwiftUI version).

### D11 · Notes are our own words, bundled in the app
2026-11-11 · Accepted

The repo is public and the notes feed the model. Writing them ourselves avoids copying Apple's documentation and keeps the tone consistent. Each note links to developer.apple.com.

### D12 · Verification labels instead of claims
2026-11-11 · Accepted

Nobody on the project has a physical Duo. Each API carries a status (Planned, Built, Simulator, Device) in DUO_APIS.md, and "Device" requires a linked report from someone who tested on hardware.

### D13 · "Open the matching demo" is a structured-output field, not a tool
2026-11-11 · Accepted

The answer type has `suggestedDemos: [DemoID]`, and `DemoID` is `Generable`, so the model can only name demos that exist. The UI shows buttons; navigation happens only on tap. More reliable than hoping a small model calls an `openDemo` tool, and it never moves the screen mid-answer. Tools are used for retrieval and device state, where they fit.

### D14 · Inner/outer display is inferred
2026-11-11 · Accepted

The iOS 27.1 SDK has no public API that names the active display. `DisplayInference` derives it from hinge status and size class, and the UI labels it "inferred". Replace it if Apple adds an API.

### D15 · Recordings are JSON files, not SwiftData
2026-11-11 · Accepted

A recording is written once and exported often. Plain `Codable` JSON in Application Support is easy to read, export and test, and learners can open the files. No queries are needed that would justify a database.

### D16 · Verify API names against the SDK with a script
2026-11-11 · Accepted

The Duo SDK is newer than most tools' and models' knowledge, and online articles disagree. `scripts/verify-sdk-symbols.sh` greps the installed SDK; every API name DuoLab depends on is listed in `scripts/sdk-symbols.txt`.
