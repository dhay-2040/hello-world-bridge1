import SwiftUI

struct GoalResultView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.appOrange)
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundStyle(Color.appGray)
            
            Button {
                
            }label: {
                Text("Set a goal")
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

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GoalResultView(icon: "hands.clap.fill", title: "Well done!", subtitle: "Ready for your next goal?")
    }
}
    
