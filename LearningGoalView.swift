import SwiftUI

struct LearningGoalView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var learningText: String
    @State private var selectedDuration: String
    @State private var showAlert = false

    // Orange measured from the design
    private let designOrange = Color(red: 230 / 255, green: 141 / 255, blue: 64 / 255)

    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel
        _learningText = State(initialValue: viewModel.learningText)
        _selectedDuration = State(initialValue: viewModel.selectedDuration)
    }

    var canUpdate: Bool {
        let text = learningText.trimmingCharacters(in: .whitespaces)
        let changed = text != viewModel.learningText || selectedDuration != viewModel.selectedDuration
        return !text.isEmpty && changed
    }

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
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .controlSize(.large)

                        Spacer()

                        checkButton
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
                                .glassEffect(.regular.interactive(), in: Capsule())
                        }
                        .buttonStyle(.plain)

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
                                .glassEffect(.regular.tint(designOrange).interactive(), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 8)
                }
                .padding(16)
                .frame(width: 270)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // ✓ button: orange glass when there is a change, dark glass otherwise
    @ViewBuilder
    private var checkButton: some View {
        if canUpdate {
            Button {
                showAlert = true
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular.tint(designOrange).interactive(), in: Circle())
            }
            .buttonStyle(.plain)
        } else {
            Button { } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.appGray)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
            .disabled(true)
        }
    }
}

#Preview {
    NavigationStack {
        LearningGoalView(viewModel: ActivityViewModel())
    }
    .preferredColorScheme(.dark)
}
