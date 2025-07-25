import SwiftUI

struct FollowersView: View {
    let followers = Array(repeating: "@Username", count: 12)
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Full-Screen Darker Blue Background
            Color(red: 0.5, green: 0.75, blue: 1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header content (back button + "100 Followers")
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 6) {
                        Spacer(minLength: 60)
                        
                        Text("100")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Followers")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        
                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Back Button
                    Button(action: {
                        print("Back tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                    .padding(.leading)
                    .padding(.top, 60)
                }
                
                // Light Blue Section with Rounded Top Corners
                ZStack {
                    Color(red: 0.9, green: 0.95, blue: 1.0)
                        .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea(edges: .bottom)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(followers.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Text(followers[index])
                                        .fontWeight(.semibold)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
}

// Utility for custom corner rounding
struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Preview
#Preview {
    FollowersView()
}
