import SwiftUI

enum GoalStatus {
    case completed
    case failed

    var icon: String {
        switch self {
        case .completed:
            return "hands.clap.fill"
        case .failed:
            return "xmark.seal.fill"
        }
    }

    var title: String {
        switch self {
        case .completed:
            return "Will done!"
        case .failed:
            return "You didn't reach your goal this time."
        }
    }

    var subtitle: String {
        switch self {
        case .completed:
            return "Ready for your next goal?"
        case .failed:
            return "Want to set another goal?"
        }
    }
}

struct GoalResultView: View {
    let status: GoalStatus
    let onSetGoal: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Spacer()

            Image(systemName: status.icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.appOrange)

            Text(status.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(status.subtitle)
                .font(.system(size: 12))
                .foregroundStyle(Color.appGray)

            Button {
                onSetGoal()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "pencil.and.outline")
                    Text("Set a goal")
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.appOrange)
                .clipShape(Capsule())
            }
            .padding(.top, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Completed") {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalResultView(status: .completed, onSetGoal: {})
    }
}

#Preview("Failed") {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalResultView(status: .failed, onSetGoal: {})
    }
}
