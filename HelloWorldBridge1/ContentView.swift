import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @State private var hasStarted = false

    var body: some View {
        if hasStarted {
            ActivityView(viewModel: viewModel)
        } else {
            OnboardingView(viewModel: viewModel) {
                hasStarted = true
            }
        }
    }
}

#Preview {
    ContentView()
}
