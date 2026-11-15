import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var showGoalScreen = false
    @State private var showCalendar = false

    private let letters = ["S", "M", "T", "W", "T", "F", "S"]
    private let mainWidth: CGFloat = 272

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                header
                weekStrip
                statCards

                Spacer()
                mainContent
                Spacer()
                bottomContent
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .onAppear { viewModel.checkStreak() }
        .sheet(isPresented: $showGoalScreen) {
            NavigationStack {
                LearningGoalView(viewModel: viewModel)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .sheet(isPresented: $showCalendar) {
            CalendarView(viewModel: viewModel)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Activity")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .onLongPressGesture { viewModel.cycleDemoState() }
                Text(viewModel.todayText)
                    .font(.subheadline)
                    .foregroundColor(.appGray)
            }
            Spacer()
            Button { showCalendar = true } label: {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.appCard))
            }
            Button { showGoalScreen = true } label: {
                Image(systemName: "pencil.and.outline")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.appCard))
            }
        }
    }

    private var weekStrip: some View {
        HStack {
            ForEach(Array(viewModel.weekDays.enumerated()), id: \.offset) { index, date in
                VStack(spacing: 8) {
                    Text(letters[index])
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.title3)
                        .foregroundColor(viewModel.dayTextColor(for: date))
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(viewModel.dayColor(for: date)))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var statCards: some View {
        HStack(spacing: 12) {
            statCard(icon: "flame.fill", color: .appOrange,
                     value: viewModel.daysText(viewModel.learnedDays), label: "Learned")
            statCard(icon: "snowflake", color: .appCyan,
                     value: viewModel.daysText(viewModel.freezedDays), label: "Freezed")
        }
    }

    private func statCard(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(color)
            Text(value).font(.headline).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 96)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.appCard))
    }

    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.goalState {
        case .inProgress:
            Button { viewModel.logLearned() } label: {
                Text(viewModel.isLoggedToday ? "Learned Today" : "Log as Learned")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: mainWidth, height: mainWidth)
                    .background(Circle().fill(Color.appOrange))
                    .opacity(viewModel.isLogDisabled ? 0.4 : 1)
            }
            .disabled(viewModel.isLogDisabled)
            .frame(maxWidth: .infinity)

        case .completed:
            GoalResultView(status: .completed) { showGoalScreen = true }
                .frame(maxWidth: .infinity)

        case .notMet:
            GoalResultView(status: .failed) { showGoalScreen = true }
                .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var bottomContent: some View {
        if viewModel.goalState == .inProgress {
            VStack(spacing: 10) {
                Button { viewModel.freezeDay() } label: {
                    Text("Freeze for a day")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: mainWidth, height: 52)
                        .background(Capsule().fill(Color.appCyan))
                        .opacity(viewModel.isFreezeDisabled ? 0.4 : 1)
                }
                .disabled(viewModel.isFreezeDisabled)

                Text("\(viewModel.usedFreezes) out of \(viewModel.maxFreezes) Freezes used")
                    .font(.footnote)
                    .foregroundColor(.appGray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("Default") {
    ActivityView(viewModel: ActivityViewModel())
}

#Preview("Auto: not met") {
    let vm = ActivityViewModel()
    vm.goalStartDate = Calendar.current.date(byAdding: .day, value: -7, to: vm.today)!
    return ActivityView(viewModel: vm)
}

#Preview("Auto: completed") {
    let vm = ActivityViewModel()
    let start = Calendar.current.date(byAdding: .day, value: -7, to: vm.today)!
    vm.goalStartDate = start
    for i in 0..<7 {
        vm.loggedDates.insert(Calendar.current.date(byAdding: .day, value: i, to: start)!)
    }
    vm.learnedDays = 7
    return ActivityView(viewModel: vm)
}
