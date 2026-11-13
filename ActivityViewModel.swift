import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {
    @Published var learnedDays = 4
    @Published var freezedDays = 0
    @Published var isLoggedToday = false
    @Published var isFreezedToday = false
    @Published var usedFreezes = 0
    let maxFreezes = 2
    enum GoalState {
        case inProgress
        case completed
        case notMet
    }

    @Published var goalState: GoalState = .inProgress
    @Published var freezedDates: Set<Int> = []
    
    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }
    
    var isFreezeDisabled: Bool {
        isFreezedToday || isLoggedToday || usedFreezes >= maxFreezes
    }
    
    func logLearned() {
        if !isLoggedToday {
            learnedDays += 1
            isLoggedToday = true
        }
    }
    
    func freezeDay() {
        if !isFreezeDisabled  {
            freezedDays += 1
            usedFreezes += 1
            isFreezedToday = true
            freezedDates.insert(24)
        }
    }
    func dayColor(for day: Int) -> Color {
        if freezedDates.contains(day) { return Color.appCyan.opacity(day == 24 ? 1 : 0.25) }
        if day == 24 { return Color.appOrange }
        return day < 24 ? Color.appOrange.opacity(0.2) : Color.clear
    }
    }

