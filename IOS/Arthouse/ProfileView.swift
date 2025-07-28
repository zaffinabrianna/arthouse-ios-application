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
    @State private var userPosts: [BlogPost] = []
    @State private var isLoading = false
    
    var username: String {
        "@\(authVM.currentUser?.username ?? "username")"
    }
    
    let bio = "This is where the user writes their bio"
    
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
                            HStack {
                                Text("All Posts")
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("\(userPosts.count)")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                        }
                        
                        ScrollView {
                            if isLoading {
                                ProgressView()
                                    .padding()
                            } else if userPosts.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray.opacity(0.5))
                                    Text("No posts yet")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Text("Share your first post!")
                                        .font(.subheadline)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .padding(.top, 50)
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 2) {
                                    ForEach(0..<userPosts.count, id: \.self) { index in
                                        NavigationLink(destination: PostDetailView(post: userPosts[index])) {
                                            Rectangle()
                                                .fill(Color.blue.opacity(0.3))
                                                .aspectRatio(1, contentMode: .fit)
                                                .overlay(
                                                    VStack {
                                                        Image(systemName: "photo")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 20))
                                                        Text("Post \(index + 1)")
                                                            .foregroundColor(.white)
                                                            .font(.caption)
                                                    }
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                            }
                        }
                        .refreshable {
                            await fetchUserPosts()
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
        .onAppear {
            fetchUserPosts()
        }
    }
    
    func fetchUserPosts() {
        Task {
            await fetchUserPosts()
        }
    }
    
    @MainActor
    func fetchUserPosts() async {
        isLoading = true
        
        guard let currentUsername = authVM.currentUser?.username else {
            print("No current user")
            isLoading = false
            return
        }
        
        guard let url = URL(string: "http://localhost:5001/api/posts") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = json["success"] as? Bool, success,
               let postsArray = json["posts"] as? [[String: Any]] {
                
                var fetchedPosts: [BlogPost] = []
                
                for postData in postsArray {
                    if let username = postData["username"] as? String,
                       let caption = postData["caption"] as? String,
                       username == currentUsername { // Only show your own posts
                        
                        let post = BlogPost(
                            id: UUID(),
                            authorName: username.capitalized,
                            authorHandle: "@\(username)",
                            imageName: "placeholder_image",
                            likeCount: postData["like_count"] as? Int ?? 0,
                            caption: caption
                        )
                        fetchedPosts.append(post)
                    }
                }
                
                self.userPosts = fetchedPosts
                print("✅ Loaded \(fetchedPosts.count) posts for user profile")
            } else {
                print("No posts found or invalid response")
                self.userPosts = []
            }
        } catch {
            print("Error fetching user posts: \(error)")
        }
        
        isLoading = false
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
