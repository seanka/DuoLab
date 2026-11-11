# Ask DuoLab: AI design

Status: design, not built · Last updated: 2026-11-11

Ask DuoLab is a search box that answers questions about iPhone Duo and its APIs from DuoLab's own notes, can point to the matching demo, and can explain what the device is doing right now.

## Scope

**Does**
- Answer questions about Duo APIs, device behavior and DuoLab's demos, citing the notes it used.
- Suggest demos to open.
- Read live device state (hinge, size classes, inferred display, reserved regions) when the question is about "now".

**Doesn't** (see PRODUCT non-goals)
- Generate code. A small model invents API names, and this app teaches API names.
- Chat about anything else, browse the web, or read the user's files.
- Send anything off the device unless the user turned on Private Cloud Compute.

## Models

All from the `FoundationModels` framework in the iOS 27.1 SDK.

| Model | Type | Used when | Availability reasons to handle |
|---|---|---|---|
| On-device | `SystemLanguageModel.default` (iOS 26+) | Default, always tried first | `deviceNotEligible`, `appleIntelligenceNotEnabled`, `modelNotReady` |
| Private Cloud Compute | `PrivateCloudComputeLanguageModel()` (iOS 27+) | Only when **Settings → Allow Private Cloud Compute** is on | `deviceNotEligible`, `systemNotReady`; also `quotaUsage` (status, `resetDate`) |
| Keyword search | ours (`KeywordSearch`) | No model can answer | none |

Both model types conform to the `LanguageModel` protocol, so one `LanguageModelSession(model:tools:instructions:)` code path serves both. Read `contextSize` from the model at runtime; don't hard-code a context budget.

### Routing (`ModelRouter`)

```
if onDevice is available:
    answer on-device
    if it fails with a context-size error:
        if PCC allowed and available and quota ok: retry on PCC
        else: retry once on-device with fewer note chunks, then fall back to keyword search
else if PCC allowed and available and quota ok:
    answer on PCC
else:
    keyword search, with a banner saying why the model isn't available
```

Every answer carries an `AnswerSource` (`.onDevice`, `.privateCloud`, `.keywordSearch`) and the UI shows it as a badge. Routing is a pure function of (availabilities, setting, quota, error) so it is unit-tested with fakes.

### What Private Cloud Compute receives

When PCC answers, the question, the note chunks retrieved for it, and the device-state summary (if the tool was called) go to Apple's Private Cloud Compute. Recordings, files, and anything else stay on the device. The Settings toggle says this in one sentence. The toggle is off by default and its state is never changed by the app.

## Retrieval

**Corpus:** every file in `Resources/Notes/` plus the `DemoCatalog` metadata (title, summary, symbols).

**Indexing (`NotesIndex`):**
- Split each note at `##` headings. Each chunk becomes a `CSSearchableItem` with `uniqueIdentifier = "note:<note-id>#<section-slug>"`, the note title, the section text, and the demo's symbols as keywords.
- Index into a private, app-owned `CSSearchableIndex(name: "DuoLabNotes")`. These items are for Ask DuoLab, not for system Spotlight results.
- Re-index on launch when the SHA-256 of the bundled notes differs from the stored hash. Index off the main actor.

**Search tool: decide in a spike (ROADMAP phase 4).** Two candidates:
1. `SpotlightSearchTool` with a `CoreSpotlightSource` (iOS 27, in the `_CoreSpotlight_FoundationModels` cross-import overlay, available when a file imports both CoreSpotlight and FoundationModels). Less code, but its behavior over a private app index is undocumented.
2. Our own `SearchNotesTool` that queries the same index with `CSSearchQuery` (or ranks in memory) and returns the top chunks.

Pick by running the eval set below with each. Record the result in DECISIONS.md. Either way, tool output is compact: top 4 chunks, each trimmed to about 600 characters, each prefixed with its note ID so the model can cite it.

## Tools

| Tool | Arguments (`@Generable`) | Returns | Side effects |
|---|---|---|---|
| `searchNotes` | `query: String` | Top chunks: `[note-id#section] text` | None |
| `currentDeviceState` | none | One-paragraph summary of the current `DeviceSnapshot`, with API names for each value | None. Reads `DeviceStateMonitor`, contains no personal data |

Tool names and descriptions are short; they count against the context window.

**Opening demos is not a tool.** The answer type has a `suggestedDemos: [DemoID]` field, and `DemoID` is `Generable`, so generation can only produce demos that exist. The UI shows them as buttons and navigates through `AppRouter` only when the user taps. This is more reliable with a small model than hoping it calls a tool, and it never yanks the screen away mid-answer (D13).

## Answer shape

```swift
// Sketch. Verify every symbol with scripts/verify-sdk-symbols.sh before using it.
@Generable
struct AskAnswer {
    @Guide(description: "One to three short paragraphs answering the question, using only facts from the tool results.")
    var answer: String

    @Guide(description: "IDs of the notes used, exactly as they appeared in the tool results, like note-id#section.")
    var citations: [String]

    @Guide(description: "Demos the user could open to see this behavior. Empty if none fit.")
    var suggestedDemos: [DemoID]
}
```

Stream it with `session.streamResponse(to: question, generating: AskAnswer.self)` so the text appears as it is generated.

## Instructions (draft)

```
You are the guide inside DuoLab, an app for iOS developers learning iPhone Duo APIs.

Before answering any question about an API or device behavior, call searchNotes.
Answer only with facts found in the tool results. If the notes don't cover the question,
say that DuoLab doesn't have a note about it yet. Don't guess.

Only mention API names that appear in the tool results. Never make up an API name.

If the question is about what the device is doing right now, call currentDeviceState.

If the question isn't about iPhone Duo, iOS development for Duo, or DuoLab, say that you
can only help with those topics.

Keep answers short and plain. Don't write code.
```

Keep the instructions in a Swift file (`Core/Intelligence/AskInstructions.swift`), and keep this section in sync with it.

## Guardrails after generation

- **Citation check:** drop citations that don't match a retrieved chunk ID. If none remain, show the answer with a "not grounded" warning and the keyword results under it.
- **Symbol check (`SymbolCheck`):** collect identifiers in the answer that look like API names (backticked, or camelCase/PascalCase followed by `(`). Anything not in the union of `DemoEntry.symbols` is highlighted as **unverified**.
- **Errors:** handle both error families: `LanguageModelSession.GenerationError` (for example `exceededContextWindowSize`, `guardrailViolation`, `refusal`, `rateLimited`, `concurrentRequests`, `unsupportedLanguageOrLocale`, `assetsUnavailable`) and the iOS 27 `LanguageModelError` (for example `contextSizeExceeded`, `timeout`, `unsupportedCapability`). The spike should note which one each model throws. Every error maps to a user-facing message plus keyword results.

## Sessions

- v1 is **single-turn**: a new `LanguageModelSession` per question. Simple, no context buildup, easier to evaluate.
- Call `session.prewarm(promptPrefix:)` when the Ask tab appears.
- Follow-up questions (multi-turn with a trimmed transcript) are a later improvement, not v1.

## Evals

A fixed question set, run by hand on a Mac with Apple Intelligence enabled (the simulator uses the host Mac's model) and, when possible, on a Duo. Results go in a table in this file with the date, model and pass count.

| # | Question | Pass if |
|---|---|---|
| 1 | How do I know if the phone is folded? | Cites `hinge`; suggests demo `hinge` |
| 2 | What is a reserved region? | Cites `reserved-regions` |
| 3 | Why did my toolbar move to the side? | Cites `vertical-bars` |
| 4 | How do I show two panes on the inner screen? | Cites `arrangement`; suggests demo `arrangement` |
| 5 | Which front camera is being used right now? | Cites `front-cameras` |
| 6 | Can I show something on the outer screen while taking a photo? | Cites `capture-accessory` |
| 7 | What's the hinge angle right now? | Calls `currentDeviceState`; reports the value or "no hinge" |
| 8 | Is the outer display compact width? | Cites `size-classes` |
| 9 | How do I make a sheet open on one side? | Cites `sheet-placement` |
| 10 | How do I use onFoldChange? | Says there's no note on it; doesn't describe a fake API |
| 11 | How do I make a SwiftUI list? | Says it only covers Duo topics, or answers only from notes |
| 12 | What's the weather today? | Declines as out of scope |

Bar for v1: at least 10 of 12 pass on the on-device model, and questions 10 and 12 always pass.

## Results log

| Date | Model | Retrieval | Passed | Notes |
|---|---|---|---|---|
| | | | | |
