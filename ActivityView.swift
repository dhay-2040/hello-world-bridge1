import SwiftUI

struct ActivityView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @State private var showGoalScreen = false
    @State private var showCalendar = false

    let letters = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Activity")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)

                    Spacer()

                    Button {
                        showCalendar = true
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }

                    Button {
                        showGoalScreen = true
                    } label: {
                        Image(systemName: "pencil.and.outline")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                }

                Text(viewModel.todayText)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appGray)

                HStack(spacing: 0) {
                    ForEach(Array(viewModel.weekDays.enumerated()), id: \.offset) { index, date in
                        VStack(spacing: 6) {
                            Text(letters[index])
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)

                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.system(size: 20))
                                .foregroundStyle(viewModel.dayTextColor(for: date))
                                .frame(width: 40, height: 40)
                                .background(viewModel.dayColor(for: date))
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 16)

                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(Color.appOrange)
                        Text(viewModel.daysText(viewModel.learnedDays))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Learned")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    VStack(spacing: 4) {
                        Image(systemName: "snowflake")
                            .foregroundStyle(Color.appCyan)
                        Text(viewModel.daysText(viewModel.freezedDays))
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Freezed")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .padding(.top, 16)

                switch viewModel.goalState {
                case .inProgress:
                    Spacer()

                    Button {
                        viewModel.logLearned()
                    } label: {
                        Text(viewModel.isLoggedToday ? "Logged as Learned" : "Log as Learned")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(viewModel.isLogDisabled ? Color.appGray : Color.white)
                            .frame(width: 272, height: 272)
                            .background(viewModel.isLogDisabled ? Color.appCard : Color.appOrange)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.isLogDisabled)
                    .frame(maxWidth: .infinity)

                    Spacer()

                    Button {
                        viewModel.freezeDay()
                    } label: {
                        Text(viewModel.isFreezedToday ? "Freezed for a day" : "Freeze for a day")
                            .font(.system(size: 17))
                            .foregroundStyle(viewModel.isFreezeDisabled ? Color.appGray : Color.white)
                            .frame(width: 272, height: 48)
                            .background(viewModel.isFreezeDisabled ? Color.appCard : Color.appCyan)
                            .clipShape(Capsule())
                    }
                    .disabled(viewModel.isFreezeDisabled)
                    .frame(maxWidth: .infinity)

                    Text("\(viewModel.usedFreezes) out of \(viewModel.maxFreezes) Freezes used")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appGray)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                case .completed:
                    GoalResultView(status: .completed, onSetGoal: { showGoalScreen = true })

                case .notMet:
                    GoalResultView(status: .failed, onSetGoal: { showGoalScreen = true })
                }
            }
            .padding(.horizontal, 17)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            viewModel.checkStreak()
        }
        .sheet(isPresented: $showGoalScreen) {
            NavigationStack {
                LearningGoalView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showCalendar) {
            CalendarView(viewModel: viewModel)
        }
    }
}

#Preview {
    ActivityView()
}
