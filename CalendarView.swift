import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @Environment(\.dismiss) private var dismiss

    let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    func monthTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func monthStart(of date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }

    var months: [Date] {
        let calendar = Calendar.current
        var result: [Date] = []
        var current = monthStart(of: viewModel.goalStartDate)
        let last = monthStart(of: viewModel.today)

        while current <= last {
            result.append(current)
            guard let next = calendar.date(byAdding: .month, value: 1, to: current) else { break }
            current = next
        }
        return result
    }

    func daysInMonth(_ monthStart: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        let offset = calendar.component(.weekday, from: monthStart) - 1
        let days: [Date?] = range.map {
            calendar.date(byAdding: .day, value: $0 - 1, to: monthStart)
        }
        return [Date?](repeating: nil, count: offset) + days
    }

    func textColor(for date: Date) -> Color {
        if viewModel.freezedDates.contains(date) { return Color.appCyan }
        if date == viewModel.today { return Color.white }
        if viewModel.loggedDates.contains(date) { return Color.appOrange }
        return Color.white
    }

    func backgroundColor(for date: Date) -> Color {
        if viewModel.freezedDates.contains(date) { return Color.appCyan.opacity(0.25) }
        if date == viewModel.today { return Color.appOrange }
        if viewModel.loggedDates.contains(date) { return Color.appOrange.opacity(0.2) }
        return Color.clear
    }

    func monthView(_ month: Date) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(monthTitle(month))
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 24)

            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.appGray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 16)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(daysInMonth(month).enumerated()), id: \.offset) { _, date in
                    if let date {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.system(size: 20))
                            .foregroundStyle(textColor(for: date))
                            .frame(width: 40, height: 40)
                            .background(backgroundColor(for: date))
                            .clipShape(Circle())
                    } else {
                        Color.clear
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.top, 8)

            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
                .padding(.top, 16)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Text("Activities")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                }
                .padding(.top, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(months, id: \.self) { month in
                            monthView(month)
                        }
                    }
                }
            }
            .padding(.horizontal, 17)
        }
    }
}

#Preview {
    let viewModel = ActivityViewModel()
    let calendar = Calendar.current
    viewModel.goalStartDate = calendar.date(byAdding: .month, value: -2, to: Date()) ?? Date()

    for offset in 1...20 {
        if let date = calendar.date(byAdding: .day, value: -offset, to: viewModel.today) {
            if offset % 7 == 0 {
                viewModel.freezedDates.insert(date)
            } else {
                viewModel.loggedDates.insert(date)
            }
        }
    }

    return CalendarView(viewModel: viewModel)
}
