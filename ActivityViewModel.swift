import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {
    @Published var learnedDays = 0
    @Published var freezedDays = 0
    @Published var loggedDates: Set<Date> = []
    @Published var freezedDates: Set<Date> = []
    @Published var usedFreezes = 0
    @Published var lastActivityDate: Date? = nil
    @Published var selectedDuration = "Week"
    @Published var learningText = "Swift"
    @Published var goalStartDate = Calendar.current.startOfDay(for: Date())

    enum GoalState { case inProgress, completed, notMet }
    @Published var goalState: GoalState = .inProgress

    // Saved before logging, so Undo can restore it
    private var lastActivityBeforeLog: Date? = nil

    var today: Date { Calendar.current.startOfDay(for: Date()) }

    var todayText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: Date())
    }

    var weekDays: [Date] {
        let cal = Calendar.current
        let offset = cal.component(.weekday, from: today) - 1
        let sunday = cal.date(byAdding: .day, value: -offset, to: today)!
        return (0..<7).map { cal.date(byAdding: .day, value: $0, to: sunday)! }
    }

    var isLoggedToday: Bool { loggedDates.contains(today) }
    var isFreezedToday: Bool { freezedDates.contains(today) }
    var isLogDisabled: Bool { isLoggedToday }

    var maxFreezes: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 8
        default: return 96
        }
    }

    var goalDays: Int {
        switch selectedDuration {
        case "Week": return 7
        case "Month": return 30
        default: return 365
        }
    }

    var isFreezeDisabled: Bool {
        isFreezedToday || isLoggedToday || usedFreezes >= maxFreezes
    }

    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }

    func logLearned() {
        guard !isLogDisabled else { return }
        lastActivityBeforeLog = lastActivityDate
        learnedDays += 1
        loggedDates.insert(today)
        lastActivityDate = Date()
    }

    // Undo a log pressed by mistake (today only)
    func undoLog() {
        guard isLoggedToday else { return }
        loggedDates.remove(today)
        learnedDays = max(0, learnedDays - 1)
        lastActivityDate = lastActivityBeforeLog
    }

    func freezeDay() {
        guard !isFreezeDisabled else { return }
        freezedDays += 1
        usedFreezes += 1
        freezedDates.insert(today)
        lastActivityDate = Date()
    }

    func checkGoal() {
        guard goalState == .inProgress else { return }
        let cal = Calendar.current
        let elapsed = cal.dateComponents([.day], from: goalStartDate, to: today).day ?? 0
        guard elapsed >= goalDays else { return }

        var allCovered = true
        for i in 0..<goalDays {
            let day = cal.date(byAdding: .day, value: i, to: goalStartDate)!
            if !loggedDates.contains(day) && !freezedDates.contains(day) {
                allCovered = false
                break
            }
        }
        goalState = allCovered ? .completed : .notMet
    }

    func checkStreak() {
        checkGoal()
        if let last = lastActivityDate,
           Date().timeIntervalSince(last) > 32 * 3600 {
            learnedDays = 0
        }
    }

    func updateGoal(text: String, duration: String) {
        learningText = text
        selectedDuration = duration
        learnedDays = 0
        freezedDays = 0
        usedFreezes = 0
        loggedDates = []
        freezedDates = []
        lastActivityDate = nil
        lastActivityBeforeLog = nil
        goalStartDate = today
        goalState = .inProgress
    }

    // Demo only: long-press on the "Activity" title to preview each goal state
    func cycleDemoState() {
        switch goalState {
        case .inProgress: goalState = .completed
        case .completed: goalState = .notMet
        case .notMet: goalState = .inProgress
        }
    }

    func dayColor(for date: Date) -> Color {
        if freezedDates.contains(date) { return Color.appCyan.opacity(0.25) }
        if date == today { return Color.appOrange }
        if loggedDates.contains(date) { return Color.appOrange.opacity(0.2) }
        return .clear
    }

    func dayTextColor(for date: Date) -> Color {
        if freezedDates.contains(date) { return Color.appCyan }
        if date == today { return .white }
        if loggedDates.contains(date) { return Color.appOrange }
        return .white
    }
}
