import SwiftUI

struct ActivityView: View {
    @State private var learnedDays = 4
    @State private var freezedDays = 0
    @State private var isLoggedToday = false
    @State private var isFreezedToday = false
    @State private var usedFreezes = 0
    let maxFreezes = 2

    let letters = ["S", "M", "T", "W", "T", "F", "S"]

    func dayLetter(for day: Int) -> String {
        letters[day - 20]
    }

    func daysText(_ count: Int) -> String {
        count == 1 ? "\(count) day" : "\(count) days"
    }

    var isFreezeDisabled: Bool {
        isFreezedToday || isLoggedToday || usedFreezes >= maxFreezes
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
                        Text(daysText(learnedDays))
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
                        Text(daysText(freezedDays))
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
                    if !isLoggedToday {
                        learnedDays += 1
                        isLoggedToday = true
                    }
                } label: {
                    Text(isLoggedToday ? "Logged as Learned" : "Log as Learned")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(isLoggedToday ? Color.appGray : Color.white)
                        .frame(width: 272, height: 272)
                        .background(isLoggedToday ? Color.appCard : Color.appOrange)
                        .clipShape(Circle())
                }
                .disabled(isLoggedToday)
                .frame(maxWidth: .infinity)

                Spacer()

                Button {
                    if !isFreezeDisabled {
                        freezedDays += 1
                        usedFreezes += 1
                        isFreezedToday = true
                    }
                } label: {
                    Text(isFreezedToday ? "Freezed for a day" : "Freeze for a day")
                        .font(.system(size: 17))
                        .foregroundStyle(isFreezeDisabled ? Color.appGray : Color.white)
                        .frame(width: 272, height: 48)
                        .background(isFreezeDisabled ? Color.appCard : Color.appCyan)
                        .clipShape(Capsule())
                }
                .disabled(isFreezeDisabled)
                .frame(maxWidth: .infinity)

                Text("\(usedFreezes) out of \(maxFreezes) Freezes used")
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
