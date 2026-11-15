import SwiftUI

struct LearningGoalView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var learningText = "Swift"
    @State private var selectedDuration = "Week"
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // الشريط العلوي
                ZStack {
                    Text("Learning Goal")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.appOrange)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.top, 8)

                GoalFormView(
                    learningText: $learningText,
                    selectedDuration: $selectedDuration
                )
                .padding(.top, 32)

                Spacer()
            }
            .padding(.horizontal, 17)
            .blur(radius: showAlert ? 3 : 0)
            .opacity(showAlert ? 0.5 : 1)

            // الـ Alert المخصص
            if showAlert {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Update goal")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("If you update now, your streak will start over.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.appGray)

                    HStack(spacing: 8) {
                        Button {
                            showAlert = false
                        } label: {
                            Text("Dismiss")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Capsule())
                        }

                        Button {
                            viewModel.updateGoal(text: learningText, duration: selectedDuration)
                            showAlert = false
                            dismiss()
                        } label: {
                            Text("Update")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.appOrange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(16)
                .frame(width: 270)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        LearningGoalView(viewModel: ActivityViewModel())
    }
}
