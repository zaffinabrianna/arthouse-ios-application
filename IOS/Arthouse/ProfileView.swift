//
// ProfileView.swift
// ArtHouse
//
// Front-End: Brianna Zaffina
// Back-End: Roberto Chavez & Jacob Nguyen
import SwiftUI

struct ProfileView: View {
    @State private var isFollowing = false
    @State private var followerCount = 100
    @State private var followingCount = 342
    
    let username = "@Username"
    let bio = "This is where the user writes their bio"
    
    let posts = [
        "underwater_photo",
        "sunset_photo",
        "art_photo",
        "nature_photo"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Blue background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Edit and Back Buttons
                HStack {
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
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        //Edit Button:
                        print("Edit Button Tapped")
                    }) {
                        // EDIT BUTTON FRONT-END:
                        Text("Edit")
                            .foregroundColor(.black) // Edit Button Text Color
                            .font(.system(size: 16, weight: .medium)) // Edit Button Font & Weight
                            .padding(.horizontal, 20) // Padding for button
                            .padding(.vertical, 8) // Padding
                            .background(Color.white.opacity(0.7)) // Button Color
                            .cornerRadius(20) // Make into Oval
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .zIndex(2)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 180) // for floating profile pic
                    
                    VStack(spacing: 16) {
                        // Follower / Following:
                        HStack(spacing: 200) {
                            // FOLLOWER FRONT END:
                            VStack(spacing: 4) {
                                Text("\(followerCount)")
                                    .font(.system(size: 20, weight: .bold)) // Count of Followers
                                    .foregroundColor(.black)
                                Text("Followers")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(followingCount)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                Text("Following")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Username and Bio
                        VStack(spacing: 8) {
                            //USERNAME FRONT-END:
                            Text(username)
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(.black)
                            
                            //BIO FRONT-END
                            Text(bio)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Follow Button
                        Button(action: {
                            toggleFollow()
                        }) {
                            Text(isFollowing ? "Following" : "Follow")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 40)
                                .background(isFollowing ? Color.gray : Color.blue)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 4)
                        }
                        
                        // All Posts Section
                        VStack(spacing: 8) {
                            Text("All Posts")
                                .font(.system(size: 25, weight: .medium))
                                .foregroundColor(.black)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                        }
                        
                        // Post Grid
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 2) {
                                ForEach(0..<posts.count, id: \.self) { index in
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(
                                            Image(systemName: getPlaceholderIcon(for: index))
                                                .foregroundColor(.white)
                                                .font(.system(size: 30))
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.88))
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
                .zIndex(1)
                
                // Floating Profile Picture
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 50))
                    )
                    .offset(y: 130)
                    .zIndex(3)
            }
        }
    }
    
    // Toggle follow status
    func toggleFollow() {
        isFollowing.toggle()
        if isFollowing {
            followerCount += 1
            print("Started following user")
        } else {
            followerCount -= 1
            print("Unfollowed user")
        }
    }
    
    // Placeholder icons
    func getPlaceholderIcon(for index: Int) -> String {
        let icons = ["figure.diving", "sunset", "paintpalette", "leaf"]
        return icons[index % icons.count]
    }
}

#Preview {
    ProfileView()
}
