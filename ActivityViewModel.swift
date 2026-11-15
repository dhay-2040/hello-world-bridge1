import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {
    @Published var learnedDays = 4
    @Published var freezedDays = 0
    @Published var loggedDates: Set<Date> = []
    @Published var freezedDates: Set<Date> = []
    @Published var usedFreezes = 0
    @Published var lastLoggedDate: Date? = nil

    @Published var selectedDuration = "Week"
    @Published var learningText = "Swift"
    @Published var goalStartDate = Calendar.current.startOfDay(for: Date())

    var today: Date { Calendar.current.startOfDay(for: Date()) }

    var todayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }

    var weekDays: [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: today) // 1 = الأحد
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0 - (weekday - 1), to: today)
        }
    }

    var isLoggedToday: Bool { loggedDates.contains(today) }

    var isFreezedToday: Bool { freezedDates.contains(today) }

    var isLogDisabled: Bool { isLoggedToday || isFreezedToday }

    var maxFreezes: Int {
        switch selectedDuration {
        case "Week": return 2
        case "Month": return 8
        case "Year": return 96
        default: return 2
        }
    }

    enum GoalState {
        case inProgress
        case completed
        case notMet
    }

    @Published var goalState: GoalState = .inProgress

    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }

    var isFreezeDisabled: Bool {
        isFreezedToday || isLoggedToday || usedFreezes >= maxFreezes
    }

    func logLearned() {
        if !isLogDisabled {
            learnedDays += 1
            loggedDates.insert(today)
            lastLoggedDate = Date()
        }
    }

    func checkStreak() {
        guard let last = lastLoggedDate else { return }

        let hours = Date().timeIntervalSince(last) / 3600

        if hours > 32 {
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
        lastLoggedDate = nil
        goalStartDate = today 
        goalState = .inProgress
    }

    func freezeDay() {
        if !isFreezeDisabled {
            freezedDays += 1
            usedFreezes += 1
            freezedDates.insert(today)
        }
    }

    // لون خلفية دائرة اليوم
    func dayColor(for date: Date) -> Color {
        if freezedDates.contains(date) {
            return Color.appCyan.opacity(0.25)
        }
        if date == today {
            return Color.appOrange
        }
        return date < today ? Color.appOrange.opacity(0.2) : Color.clear
    }

    func dayTextColor(for date: Date) -> Color {
        if freezedDates.contains(date) {
            return Color.appCyan
        }
        if date == today {
            return Color.white
        }
        return date < today ? Color.appOrange : Color.white
    }
}
