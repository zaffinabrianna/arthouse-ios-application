import SwiftUI

struct FollowingView: View {
    let following = Array(repeating: "@Username", count: 12)
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Full-Screen Darker Blue Background
            Color(red: 0.5, green: 0.75, blue: 1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header content (back button + "100 Followers")
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 2) {
                        Text("100")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Following")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity)
                    
                    //Back Button:
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        // BACK BUTTON FRONT-END:
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black) // Button Text Color
                            .font(.system(size: 20)) // Button Text Font
                            .padding(12) // Padding (helps make button bigger)
                            .background(Color.white.opacity(0.7)) // Button Background
                            .clipShape(Circle()) // Button Shape         
                            .padding(.leading)
                    }
                    .padding(.top, 10)
                }
                
                // Light Blue Section with Rounded Top Corners
                ZStack {
                    Color(red: 0.9, green: 0.95, blue: 1.0)
                        .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea(edges: .bottom)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(following.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Text(following[index])
                                        .fontWeight(.semibold)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 40)
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

// Preview
#Preview {
    FollowingView()
}
