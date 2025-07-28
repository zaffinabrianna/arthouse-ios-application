//
// ProfileView.swift
// ArtHouse
//
// Front-End: Brianna Zaffina
// Back-End: Roberto Chavez & Jacob Nguyen

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isFollowing = false
    @State private var followerCount = 100
    @State private var followingCount = 342
    @State private var showingEditProfile = false
    @State private var showingFollowers = false
    @State private var showingFollowing = false
    
    var username: String {
        "@\(authVM.currentUser?.username ?? "username")"
    }
    
    let bio = "This is where the user writes their bio"
    
    let posts = [
        BlogPost(id: UUID(), authorName: "Your Name", authorHandle: "@username", imageName: "underwater_photo", likeCount: 45),
        BlogPost(id: UUID(), authorName: "Your Name", authorHandle: "@username", imageName: "sunset_photo", likeCount: 78),
        BlogPost(id: UUID(), authorName: "Your Name", authorHandle: "@username", imageName: "art_photo", likeCount: 123),
        BlogPost(id: UUID(), authorName: "Your Name", authorHandle: "@username", imageName: "nature_photo", likeCount: 67)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                HStack {
                    Button(action: {
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Text("Edit")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .zIndex(2)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 180)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 200) {
                            Button(action: {
                                showingFollowers = true
                            }) {
                                VStack(spacing: 4) {
                                    Text("\(followerCount)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("Followers")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: {
                                showingFollowing = true
                            }) {
                                VStack(spacing: 4) {
                                    Text("\(followingCount)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("Following")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text(username)
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text(bio)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        

                        
                        VStack(spacing: 8) {
                            Text("All Posts")
                                .font(.system(size: 25, weight: .medium))
                                .foregroundColor(.black)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                        }
                        
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 2) {
                                ForEach(0..<posts.count, id: \.self) { index in
                                    NavigationLink(destination: PostDetailView(post: posts[index])) {
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
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 140)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.88))
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
                .zIndex(1)
                
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
        .sheet(isPresented: $showingEditProfile) {
            EditProfile()
                .environmentObject(authVM)
        }
        .sheet(isPresented: $showingFollowers) {
            FollowersView()
        }
        .sheet(isPresented: $showingFollowing) {
            FollowingView()
        }
    }
    
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
    
    func getPlaceholderIcon(for index: Int) -> String {
        let icons = ["figure.diving", "sunset", "paintpalette", "leaf"]
        return icons[index % icons.count]
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
