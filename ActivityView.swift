import SwiftUI

struct ActivityView: View {
    @State private var learnedDays = 4
    @State private var freezedDays = 0
    @State private var isLoggedToday = false
    
    let letters = ["S", "M", "T", "W", "T", "F", "S"]

    func dayLetter(for day: Int) -> String {
        letters[day - 20]
    }
    
    func daysText(_ count: Int) -> String {        count == 1 ? "\(count) day" : "\(count) days"
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
                        Text(daysText(freezedDays))                            .font(.system(size: 17, weight: .semibold))
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
                    Text(isLoggedToday ? "Logged as learned" : "Log as Learned")
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
                    // لاحقاً: نجمّد اليوم
                } label: {
                    Text("Freeze for a day")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(width: 272, height: 48)
                        .background(Color.appCyan)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)

                Text("0 out of 2 Freezes used")
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
