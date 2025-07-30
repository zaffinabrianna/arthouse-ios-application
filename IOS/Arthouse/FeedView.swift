//
//  FeedView.swift
//  Arthouse
//
// Front End: Brianna Zaffina
//  Back-End: Roberto and Jacob
//

import SwiftUI

extension Color {
    static let navy = Color(red: 0, green: 0, blue: 0.9)
    static let lightBlue = Color(red: 234/255, green: 241/255, blue: 1.0)
}

struct FeedView: View {
    @Binding var selectedTab: Int
    @Binding var showUpload: Bool
    @State private var posts: [BlogPost] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else if posts.isEmpty {
                        // Empty state message
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No posts yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Be the first to share something!")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .padding(.top, 100)
                    } else {
                        // Show all the posts
                        ForEach(posts) { post in
                            PostCard(post: post)
                        }
                    }
                    Spacer(minLength: 120)
                }
                .padding(.top, -20)
                .padding(.horizontal, 16) // Better spacing from edges
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Feed")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)

                }
            }
            .refreshable {
                await fetchPosts()
            }
        }
        .onAppear {
            fetchPosts()
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == 0 { // Feed tab selected
                fetchPosts()
            }
        }
    }
    
    func fetchPosts() {
        Task {
            await fetchPosts()
        }
    }
    
    @MainActor
    func fetchPosts() async {
        isLoading = true
        
        guard let url = URL(string: "http://localhost:5001/api/posts") else {
            print("Bad URL")
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
                       let postId = postData["post_id"] as? Int {
                        
                        // Get the image URL from server response
                        let imageUrl = postData["image_url"] as? String ?? ""
                        
                        let post = BlogPost(
                            id: UUID(),
                            postId: postId,
                            authorName: username.capitalized,
                            authorHandle: "@\(username)",
                            imageName: imageUrl.isEmpty ? "placeholder_image" : imageUrl,
                            likeCount: postData["like_count"] as? Int ?? 0,
                            caption: caption
                        )
                        fetchedPosts.append(post)
                    }
                }
                
                self.posts = fetchedPosts
                print("✅ Got \(fetchedPosts.count) posts for the feed")
            } else {
                print("No posts found or bad response")
                self.posts = []
            }
        } catch {
            print("Error loading posts: \(error)")
        }
        
        isLoading = false
    }
}

// Individual post card component
struct PostCard: View {
    let post: BlogPost
    @State private var isLiked = false
    @State private var currentLikeCount: Int
    
    init(post: BlogPost) {
        self.post = post
        self._currentLikeCount = State(initialValue: post.likeCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info section
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.system(size: 20, weight: .bold))
                    Text(post.authorHandle)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Show caption if there is one
            if !post.caption.isEmpty {
                Text(post.caption)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
            
            ZStack(alignment: .bottomLeading) {
                // Load image from URL or show placeholder
                if !post.imageName.isEmpty && post.imageName != "placeholder_image" {
                    // Real image from server
                    AsyncImage(url: URL(string: post.imageName)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            )
                    }
                    .frame(height: 260)
                    .clipped()
                    .cornerRadius(20)
                } else {
                    // No image placeholder
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 260)
                        .cornerRadius(20)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No Image")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                }
                
                // Like button and count overlay
                HStack(spacing: 6) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isLiked.toggle()
                            currentLikeCount += isLiked ? 1 : -1
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .white)
                            .scaleEffect(isLiked ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLiked)
                    }
                    
                    Text("\(currentLikeCount)")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                }
                .padding(8)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(12)
                .padding(10)
            }
        }
        .padding()
        .background(Color.lightBlue)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    FeedView(selectedTab: .constant(0), showUpload: .constant(false))
}
