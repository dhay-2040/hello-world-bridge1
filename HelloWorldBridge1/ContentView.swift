import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @State private var hasStarted = false

    var body: some View {
        Group {
            if hasStarted {
                ActivityView(viewModel: viewModel)
            } else {
                OnboardingView(viewModel: viewModel) { hasStarted = true }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
