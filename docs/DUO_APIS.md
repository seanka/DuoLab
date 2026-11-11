# iPhone Duo APIs in DuoLab

Last checked against: **iOS 27.1 SDK, Xcode 27.1 (27A9275)** on 2026-11-11, with `scripts/verify-sdk-symbols.sh`.

This is the list of what DuoLab covers, which demo shows it, and how far it has been verified. When a demo changes, update its row in the same PR.

## Verification status

| Label | Meaning |
|---|---|
| ⬜ Planned | Not built yet |
| 🛠 Built | Code exists and compiles. Not checked against behavior |
| 🧪 Simulator | Checked by hand in the iPhone Duo simulator; simulator limits are noted |
| 📱 Device | Checked on a physical iPhone Duo. Needs a linked report (issue) |

Nobody on the project has a physical Duo yet, so nothing can be 📱 until someone reports it.

## Demos

### Hinge

| API | Framework | Since | Demo | Status |
|---|---|---|---|---|
| `onHingeChange(isEnabled:_:)` | SwiftUI | 27.1 | `hinge` | ⬜ |
| `DeviceHingeContext` (`.hinge`, `nil` without a hinge) | SwiftUI | 27.1 | `hinge` | ⬜ |
| `DeviceHinge` (`.status`, `.angle`), `DeviceHinge.Status` (`.closed`, `.partiallyOpen`, `.fullyOpen`) | SwiftUI | 27.1 | `hinge` | ⬜ |
| `UIHingeInteraction`, `UIHinge` (`.status`, `.angle` in radians), `UIHinge.Status` (adds `.unknown`) | UIKit | 27.1 | `hinge` (UIKit tab) | ⬜ |

### Layout

| API | Framework | Since | Demo | Status |
|---|---|---|---|---|
| `ArrangementView(primary:secondary:)` | SwiftUI | 27.1 | `arrangement` | ⬜ |
| `arrangementViewStyle(_:)`, `SplitArrangementViewStyle` (`.split`) | SwiftUI | 27.1 | `arrangement` | ⬜ |
| `splitArrangementLayoutRatio(_:)`, `splitArrangementLayoutSize(...)`, `splitArrangementFixedLayoutSize(horizontal:vertical:)` | SwiftUI | 27.1 | `arrangement` | ⬜ |
| `UIArrangementViewController`, `UISplitArrangement`, `UIOverlayArrangement` | UIKit | 27.1 | `arrangement` (UIKit tab) | ⬜ |
| `ReservedRegion` (`.kind`, `.frame`, `.margins`, `.isActive`), kinds `.division` and `.occlusion` | SwiftUI | 27.1 | `reservedRegions` | ⬜ |
| `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)`, option `.includeInactive` | SwiftUI | 27.1 | `reservedRegions` | ⬜ |
| `UIView.reservedRegions(kind:options:)` | UIKit | 27.1 | `reservedRegions` (UIKit tab) | ⬜ |

### Bars and presentation

| API | Framework | Since | Demo | Status |
|---|---|---|---|---|
| `toolbarVerticalBehavior(_:)`, environment `toolbarVerticalEdge` | SwiftUI | 27.1 | `verticalBars` | ⬜ |
| `axisBehavior(_:)`, `ToolbarItemAxisBehavior` | SwiftUI | 27.1 | `verticalBars` | ⬜ |
| `toolbarVerticalCompressionBehavior(_:)` | SwiftUI | 27.1 | `verticalBars` | ⬜ |
| `visibilityPriority(_:)`, `ToolbarOverflowMenu` | SwiftUI | 27.0 | `verticalBars` | ⬜ |
| `preferredVerticalBarBehavior`, `verticalBarEdge` | UIKit | 27.1 | `verticalBars` (UIKit tab) | ⬜ |
| `presentationPlacement(_:)` | SwiftUI | 27.0 | `sheetPlacement` | ⬜ |
| `backgroundExtensionEffect()` | SwiftUI | 26.0 | `backgroundExtension` | ⬜ |
| `UIBackgroundExtensionView` | UIKit | 26.0 | `backgroundExtension` (UIKit tab) | ⬜ |

### Cameras

| API | Framework | Since | Demo | Status |
|---|---|---|---|---|
| `AVCaptureDevice.DeviceType.builtInOuterUltraWideCamera` | AVFoundation | 27.1 | `frontCameras` | ⬜ |
| `AVCaptureDevice.DeviceType.builtInInnerUltraWideCamera` | AVFoundation | 27.1 | `frontCameras` | ⬜ |
| `activePrimaryConstituent` (which physical camera a virtual camera streams from) | AVFoundation | 15.0 | `frontCameras` | ⬜ |
| `AVCaptureDeviceDirectionCoordinator`, `AVCaptureDeviceDirectionMap` | AVKit | 27.1 | `frontCameras` | ⬜ |
| `CameraCaptureAccessory` (27.1), `sceneAccessory(content:)` and `onAvailabilityChange(perform:)` (27.0) | SwiftUI | 27.0–27.1 | `captureAccessory` | ⬜ |
| `UISceneAccessory`, `registerSceneAccessory(_:)` | UIKit | 27.0 | `captureAccessory` (UIKit tab) | ⬜ |

The "Since" column is the iOS version in the SDK's `@available` / `API_AVAILABLE` annotations, checked on 2026-11-11. Some APIs predate the Duo (27.0 or earlier) but matter most on it.

## Device facts

From secondary sources (not Apple docs), so treat them as unverified and correct them when Apple's pages or a real device say otherwise:

- Two displays: a 7.6-inch inner display with an aspect ratio of about 1.42, and a 5.4-inch outer display of about 1.45. ([Blake Crosley](https://blakecrosley.com/blog/iphone-duo-for-developers))
- The outer display is compact width in portrait like other iPhones; the inner display is regular width and height, like an iPad. (same source)
- Postures in Apple's design guidance: closed, partly folded (book), flat, standing on its edges (tent). The guidance is two layouts (compact and regular width), not one layout per posture. (same source)
- One front camera per display. The inner one sits under the display. (eCorpIT, [iPhone Duo SDK explained](https://ecorpit.com/iphone-duo-sdk-new-apis-xcode-27-1-developer-guide-2026/))
- Authentication uses Touch ID. (Blake Crosley)
- Released 23 October 2026 with iOS 27.1. ([Gadget Hacks](https://apple.gadgethacks.com/news/iphone-duo-app-developer-update-timeline-whats-confirmed/))

## Simulator notes

To fill in during ROADMAP phase 1 (PRODUCT open question Q1):
- Can the iPhone Duo simulator change hinge angle and posture? How?
- Which reserved regions does it report on each display?
- Do the inner/outer front camera device types show up in the simulator?

## Device test checklist

For anyone reporting results from a real iPhone Duo (attach to an issue):

- [ ] Hinge: status changes at closed → partly open → fully open; angle tracks smoothly
- [ ] Inspector: inferred display matches the display in use, in every posture
- [ ] Reserved regions: division and occlusion frames line up with the hinge and cameras on screen
- [ ] Arrangement: split layout moves with the hinge on the inner display
- [ ] Vertical bars: tab bar and toolbar move to the vertical edge where expected
- [ ] Sheet placement: sheets land on the requested side
- [ ] Front cameras: both device types are discovered; `activePrimaryConstituent` changes when switching displays
- [ ] Capture accessory: content appears on the outer display during capture
- [ ] Recorder: a 30-second fold produces a readable timeline
