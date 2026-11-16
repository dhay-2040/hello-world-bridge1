import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ActivityViewModel
    var onStart: () -> Void

    @State private var learningText = ""
    @State private var selectedDuration = "Week"

    // Orange measured from the design
    private let designOrange = Color(red: 230 / 255, green: 141 / 255, blue: 64 / 255)

    var canStart: Bool {
        !learningText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.appOrange)
                    .padding(.bottom, 40)

                HStack(spacing: 0) {
                    Text("Hello ")
                        .font(.system(size: 34))
                    Text("Learner")
                        .font(.system(size: 34, weight: .bold))
                }
                .foregroundStyle(.white)

                Text("This app will help you learn everyday!")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.gray)

                Text("I want to learn")
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .padding(.top, 40)

                TextField("", text: $learningText, prompt: Text("Swift").foregroundStyle(Color.gray))
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)

                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)

                Text("I want to learn it in a")
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .padding(.top, 32)

                HStack(spacing: 12) {
                    ForEach(["Week", "Month", "Year"], id: \.self) { duration in
                        let isSelected = selectedDuration == duration
                        Button {
                            selectedDuration = duration
                        } label: {
                            Text(duration)
                                .font(.system(size: 17))
                                .foregroundStyle(isSelected ? Color.white : Color.gray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .glassEffect(
                                    isSelected
                                        ? Glass.regular.tint(designOrange).interactive()
                                        : Glass.regular.interactive(),
                                    in: Capsule()
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 8)

                Spacer()

                Button {
                    viewModel.updateGoal(
                        text: learningText.trimmingCharacters(in: .whitespaces),
                        duration: selectedDuration
                    )
                    onStart()
                } label: {
                    Text("Start Learning")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(canStart ? Color.white : Color.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 11)
                        .glassEffect(
                            canStart
                                ? Glass.regular.tint(designOrange).interactive()
                                : Glass.regular,
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canStart)
                .frame(maxWidth: .infinity)

                Text("You can edit your desire later")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            }
            .padding(.horizontal, 17)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView(viewModel: ActivityViewModel(), onStart: {})
        .preferredColorScheme(.dark)
}
