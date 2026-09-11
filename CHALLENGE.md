# iOS Code Challenge — Notifications

Welcome! This challenge is based on a small SwiftUI app that displays a list of notifications for a healthcare product. The app uses a mocked network layer (`MockURLProtocol`), so no real backend is required — everything runs locally.

## Getting started

1. Open `NotificationsChallenge/NotificationsChallenge.xcodeproj` in Xcode.
2. Build and run the app (or use the SwiftUI previews).
3. You should see a "Notifications" screen… but something is wrong.

## Project overview

| File | Purpose |
| --- | --- |
| `NotificationsView.swift` | The main screen that lists notifications. |
| `NotificationsStore.swift` | Fetches and decodes data from the (mocked) API. |
| `NotificationModels.swift` | Data models for the API responses. |
| `MockURLProtocol.swift` | Serves canned JSON responses for `/notifications` and `/notifications/{id}`. |
| `Assets.xcassets` | Colors you may find useful for the redesign (see `NotificationRow/`). |

## Tasks

### 1. Fix the bug

The notifications list renders empty, even though the mock API returns three notifications. Find out why and fix it.

### 2. Redesign the list

Our design team has produced new mockups for the notifications list (they will be provided to you separately). Restyle the list to match them.

Requirements:

- Follow the provided mockups as closely as you can.
- Group the notifications by **priority** — important notifications (priority `1`) should appear in their own section above the standard ones (priority `0`). Hint: check the JSON payloads; the models may not expose everything you need yet.
- Use the color sets already available in `Assets.xcassets` under `NotificationRow/Important` and `NotificationRow/Standard` (icon background, read/unread states).

### 3. Add a details screen 🔎

Implement a simple details view and navigate to it when a notification row is tapped:

- The notification **title** should be shown in the navigation bar.
- The notification **message (body)** should be shown in the view's content.
- Use the existing `fetchDetails(id:)` API on `NotificationsStore` to load the data.

## What we look for

- A working fix with a clear understanding of the root cause.
- Clean, idiomatic SwiftUI and Swift concurrency usage.
- Attention to detail when matching the mockups.
- Sensible handling of loading and error states.

## Constraints & notes

- Keep using the mocked networking (`NotificationsStore.mocked`) — don't add a real backend.
- Third-party dependencies are not needed; please stick to first-party frameworks.
- Feel free to refactor as long as the behavior described above is met.

Good luck! 🍀
