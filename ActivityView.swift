import SwiftUI

struct ActivityView: View {
    @StateObject private var viewModel = ActivityViewModel()

    let letters = ["S", "M", "T", "W", "T", "F", "S"]

    func dayLetter(for day: Int) -> String {
        letters[day - 20]
    }

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

                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                    Image(systemName: "scope")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                }

                Text("Thursday, 24 October")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appGray)

                HStack(spacing: 0) {
                    ForEach(20...26, id: \.self) { day in
                        VStack(spacing: 6) {
                            Text(dayLetter(for: day))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)

                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundStyle(day == 24 ? Color.white : (day < 24 ? Color.appOrange : Color.white))
                                .frame(width: 40, height: 40)
                                .background(day == 24 ? Color.appOrange : (day < 24 ? Color.appOrange.opacity(0.2) : Color.clear))
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

                Spacer()

                Button {
                    viewModel.logLearned()
                } label: {
                    Text(viewModel.isLoggedToday ? "Logged as Learned" : "Log as Learned")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(viewModel.isLoggedToday ? Color.appGray : Color.white)
                        .frame(width: 272, height: 272)
                        .background(viewModel.isLoggedToday ? Color.appCard : Color.appOrange)
                        .clipShape(Circle())
                }
                .disabled(viewModel.isLoggedToday)
                .frame(maxWidth: .infinity)

                Spacer()

                Button {
                    viewModel.freezeDay()
                } label: {                    Text(viewModel.isFreezedToday ? "Freezed for a day" : "Freeze for a day")
                    .foregroundStyle(viewModel.isFreezeDisabled ? Color.appGray : Color.white)
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
            }
            .padding(.horizontal, 17)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ActivityView()
}
