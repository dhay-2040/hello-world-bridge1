import SwiftUI

struct ActivityView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Activity")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                    Image(systemName: "scope")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                }
                
                Text("Thursday, 24 October")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appGray)
                
                Spacer()
                
                Button {
                    // يتعلم
                } label: {
                    Text("Log as Learned")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 272, height: 272)
                        .background(Color.appOrange)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button {
                    // يتجمد
                }label: {
                    Text("Freeze for a day")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(width: 272, height: 48)
                        .background(Color.appCyan)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                
                Text("0 out of 2 Freezes used")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appGray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 17)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ActivityView()
}

