import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {
    @Published var learnedDays = 4
    @Published var freezedDays = 0
    @Published var isLoggedToday = false
    @Published var isFreezedToday = false
    @Published var usedFreezes = 0
    let maxFreezes = 2
    
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
        }
    }
    func dayColor(for day: Int) -> Color {
        if day == 24 && isFreezedToday { return Color.appCyan }
        if day == 24 { return Color.appOrange }
        return day < 24 ? Color.appOrange.opacity(0.2) : Color.clear
    }
}
