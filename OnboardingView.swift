import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ActivityViewModel
    var onStart: () -> Void

    @State private var learningText = ""
    @State private var selectedDuration = "Week"

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
                        Button {
                            selectedDuration = duration
                        } label: {
                            Text(duration)
                                .font(.system(size: 17))
                                .foregroundStyle(selectedDuration == duration ? .white : Color.gray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(selectedDuration == duration ? Color.appOrange : Color.white.opacity(0.12))
                                .clipShape(Capsule())
                        }
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
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Color.appOrange)
                        .clipShape(Capsule())
                }
                .disabled(!canStart)
                .opacity(canStart ? 1 : 0.5)
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
    }
}

#Preview {
    OnboardingView(viewModel: ActivityViewModel(), onStart: {})
}
