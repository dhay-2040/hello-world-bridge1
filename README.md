# Learning Journey

An iOS app to track daily learning progress and keep your streak alive.
Built with SwiftUI for the Hello World Bridge1 challenge.

## Features
- Choose what you want to learn and set a goal duration (Week, Month or Year).
- **Log as Learned** to count a learning day, with an Undo if pressed by mistake.
- **Freeze for a day** to keep your streak without learning (limits: Week 2, Month 8, Year 96).
- Weekly strip and stats cards for learned and frozen days.
- Calendar view (view only) showing logged and frozen days.
- Update your learning goal, which resets the streak after a confirmation alert.
- Streak resets after more than 32 hours without a Log or Freeze.
- Goal result screens for completed and not-met goals.
- Liquid Glass UI in dark mode, with a custom app icon.

## Tech
- SwiftUI, MVVM (one shared `ActivityViewModel`)
- `@StateObject`, `@ObservedObject`, `@State`, `@Binding`, `@Published`
- iOS 26+ Liquid Glass (`glassEffect`)

## Project structure
| File | Purpose |
|---|---|
| `ActivityViewModel.swift` | App logic and state |
| `ContentView.swift` | Entry: Onboarding or Activity |
| `OnboardingView.swift` | First screen to set the goal |
| `ActivityView.swift` | Main screen |
| `LearningGoalView.swift` / `GoalFormView.swift` | Edit goal |
| `GoalResultView.swift` | Completed or not-met result |
| `CalendarView.swift` | View-only calendar |
| `Colors.swift` | App colors |

## Run
1. Open `HelloWorldBridge1.xcodeproj` in Xcode.
2. Choose an iPhone simulator (iOS 26 or later).
3. Press Run (Cmd+R).

## Demo note
Long-press the "Activity" title to cycle between the in-progress, completed and not-met states for quick testing.

## Screenshots
[Add screenshots here]

## Author
[Your name]
