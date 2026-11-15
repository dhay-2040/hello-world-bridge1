import SwiftUI

struct LearningGoalView: View {
    @State private var learningText = ""
    @State private var selectedDuration = "Week"

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading) {
                GoalFormView(
                    learningText: $learningText,
                    selectedDuration: $selectedDuration
                )
                Spacer()
            }
            .padding(.horizontal, 17)
            .padding(.top, 24)
        }
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LearningGoalView()
    }
}
