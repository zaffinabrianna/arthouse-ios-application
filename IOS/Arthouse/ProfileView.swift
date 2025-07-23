
//
//  ProfileView.swift
//  Arthouse
//
//  
//

import SwiftUI

struct ProfileView: View {
    @State private var isFollowing = false
    @State private var followerCount = 100
    @State private var followingCount = 342
    
    // TODO: get this from actual user data later
    let username = "@Username"
    let bio = "This where the user writes their bio"
    
    // mock post data for now
    let posts = [
        "underwater_photo", // placeholder image names
        "sunset_photo",
        "art_photo",
        "nature_photo"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            HStack {
                // Back button Functionality:
                Button(action: {
                    // TODO: go back to previous screen
                    print("Back button tapped")
                }) {
                    // Back Button "<":
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black) // Color of the arrow in button
                        .font(.system(size: 20)) // Font size of back button
                        .padding(12) // Size of the circle around the back button
                        .background(Color.white.opacity(0.7)) // Color of back button bg
                        .clipShape(Circle()) // Shape of the button
                }
                
                Spacer()
                
                Button(action: {
                    // Edit button Functionality:
                    // TODO: Edit Profile Button (will go to the edit profile page)
                    print("Edit Button Tapped")
                }) {
                    // Edit Button:
                    Text("Edit")
                        .foregroundColor(.black) // "Edit" text color
                        .font(.system(size: 16, weight: .medium)) // Size and weight of font
                        .padding(12) // Circle Size around edit button
                        .padding(.horizontal, 8) // Make button longer
                        .background(Color.white.opacity(0.7)) // Color of edit button background
                        .cornerRadius(20) // Make button into an oval
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10) // push down from status bar
            
            Spacer()
            
            // main profile content
            VStack(spacing: 0) {
                // profile picture
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                    
                    // placeholder for profile image
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 50))
                }
                .padding(.bottom, 20)
                
                // followers/following stats
                HStack(spacing: 40) {
                    VStack(spacing: 4) {
                        Text("\(followerCount)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text("Followers")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(followingCount)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        Text("Following")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 20)
                
                // username and bio
                VStack(spacing: 8) {
                    Text(username)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(bio)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 25)
                
                // follow button
                Button(action: {
                    toggleFollow()
                }) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .background(isFollowing ? Color.gray : Color.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 30)
                
                // posts section header
                VStack(spacing: 0) {
                    Text("All Posts")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, 15)
                    
                    // divider line
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                
                // posts grid - simple for now
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 2) {
                        ForEach(0..<posts.count, id: \.self) { index in
                            // placeholder post images
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    // using system images as placeholders
                                    Image(systemName: getPlaceholderIcon(for: index))
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .background(
                // rounded white background
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .ignoresSafeArea(.container, edges: .bottom)
            )
        }
        .background(
            // blue gradient background like the mockup
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    // toggle follow status
    func toggleFollow() {
        isFollowing.toggle()
        // TODO: send follow request to backend
        
        if isFollowing {
            followerCount += 1
            print("Started following user")
        } else {
            followerCount -= 1
            print("Unfollowed user")
        }
    }
    
    // get placeholder icons for posts
    func getPlaceholderIcon(for index: Int) -> String {
        let icons = ["figure.diving", "sunset", "paintpalette", "leaf"]
        return icons[index % icons.count]
    }
}

#Preview {
    ProfileView()
}

