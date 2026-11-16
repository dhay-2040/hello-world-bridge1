import SwiftUI

struct GoalFormView: View {
    @Binding var learningText: String
    @Binding var selectedDuration: String

    // Orange measured from the design
    private let designOrange = Color(red: 230 / 255, green: 141 / 255, blue: 64 / 255)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("I want to learn")
                .font(.system(size: 17))
                .foregroundStyle(.white)

            TextField("", text: $learningText, prompt: Text("Swift").foregroundStyle(Color.appGray))
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.vertical, 8)

            Rectangle()
                .fill(Color.appGray.opacity(0.4))
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
                            .foregroundStyle(isSelected ? Color.white : Color.appGray)
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
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalFormView(learningText: .constant(""), selectedDuration: .constant("Week"))
            .padding(17)
    }
    .preferredColorScheme(.dark)
}
