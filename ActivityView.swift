import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var showGoalScreen = false
    @State private var showCalendar = false

    private let letters = ["S", "M", "T", "W", "T", "F", "S"]
    private let mainWidth: CGFloat = 272

    // Colors measured from the design
    private let designOrange = Color(red: 230 / 255, green: 141 / 255, blue: 64 / 255)
    private let designBlue = Color(red: 100 / 255, green: 197 / 255, blue: 238 / 255)

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
        .preferredColorScheme(.dark)
        .onAppear { viewModel.checkStreak() }
        .sheet(isPresented: $showGoalScreen) {
            NavigationStack {
                LearningGoalView(viewModel: viewModel)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showCalendar) {
            CalendarView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }

    // MARK: - Header

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
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)

            Button { showGoalScreen = true } label: {
                Image(systemName: "pencil.and.outline")
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
        }
    }

    // MARK: - Week strip & cards

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

    // Liquid Glass card (Dark / Regular), like the design
    private func statCard(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(color)
            Text(value).font(.headline).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 96)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    // MARK: - Main content (Log circle / result)

    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.goalState {
        case .inProgress:
            VStack(spacing: 16) {
                logButton

                // Undo: only visible after logging today (keeps layout stable)
                Button { viewModel.undoLog() } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.glass)
                .opacity(viewModel.isLoggedToday ? 1 : 0)
                .disabled(!viewModel.isLoggedToday)
            }
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
    private var logButton: some View {
        if viewModel.isLogDisabled {
            // Disabled: neutral dark glass, gray text
            Button { } label: {
                Text("Logged as Learned")
                    .font(.title3.bold())
                    .foregroundStyle(Color.appGray.opacity(0.7))
                    .frame(width: mainWidth - 32, height: mainWidth - 32)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .disabled(true)
        } else {
            // Enabled: orange tinted glass (design color)
            Button { viewModel.logLearned() } label: {
                Text("Log as Learned")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: mainWidth, height: mainWidth)
                    .glassEffect(.regular.tint(designOrange).interactive(), in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Bottom (Freeze)

    @ViewBuilder
    private var bottomContent: some View {
        if viewModel.goalState == .inProgress {
            VStack(spacing: 10) {
                freezeButton
                    .frame(width: mainWidth)

                Text("\(viewModel.usedFreezes) out of \(viewModel.maxFreezes) Freezes used")
                    .font(.footnote)
                    .foregroundColor(.appGray)
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var freezeButton: some View {
        if viewModel.isFreezeDisabled {
            Button { } label: {
                Text("Freezed for a day")
                    .font(.headline)
                    .foregroundStyle(Color.appGray.opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .disabled(true)
        } else {
            // Enabled: blue tinted glass (design color)
            Button { viewModel.freezeDay() } label: {
                Text("Freeze for a day")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .glassEffect(.regular.tint(designBlue).interactive(), in: Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview("Default") {
    ActivityView(viewModel: ActivityViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Auto: not met") {
    let vm = ActivityViewModel()
    vm.goalStartDate = Calendar.current.date(byAdding: .day, value: -7, to: vm.today)!
    return ActivityView(viewModel: vm).preferredColorScheme(.dark)
}

#Preview("Auto: completed") {
    let vm = ActivityViewModel()
    let start = Calendar.current.date(byAdding: .day, value: -7, to: vm.today)!
    vm.goalStartDate = start
    for i in 0..<7 {
        vm.loggedDates.insert(Calendar.current.date(byAdding: .day, value: i, to: start)!)
    }
    vm.learnedDays = 7
    return ActivityView(viewModel: vm).preferredColorScheme(.dark)
}
