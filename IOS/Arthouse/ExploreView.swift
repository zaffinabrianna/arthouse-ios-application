//
//  ExploreView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var posts: [BlogPost] = []
    @State private var showingSearch = false
    @State private var searchText = ""
    @State private var isLoading = false
    
    var filteredPosts: [BlogPost] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { post in
                post.authorName.localizedCaseInsensitiveContains(searchText) ||
                post.authorHandle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header - restored to original working spacing
                HStack {
                    Text("Explore")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSearch = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if isLoading {
                            ProgressView()
                                .padding()
                        } else if filteredPosts.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text(searchText.isEmpty ? "No posts to explore" : "No results found")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text(searchText.isEmpty ? "Check back later for new content" : "Try a different search term")
                                    .font(.subheadline)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            .padding(.top, 100)
                        } else {
                            ForEach(filteredPosts) { post in
                                PostCard(post: post)
                            }
                        }
                        Spacer(minLength: 120)
                    }
                    .padding(.top, -10)
                }
                .refreshable {
                    await fetchExplorePosts()
                }
            }
            
            // Search Overlay
            if showingSearch {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingSearch = false
                        searchText = ""
                    }
                
                VStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search users...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Button("Cancel") {
                            showingSearch = false
                            searchText = ""
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                    
                    // Search Results
                    if !searchText.isEmpty {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(filteredPosts) { post in
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .foregroundColor(.gray)
                                            .frame(width: 40, height: 40)
                                        
                                        VStack(alignment: .leading) {
                                            Text(post.authorName)
                                                .font(.headline)
                                            Text(post.authorHandle)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        showingSearch = false
                                        searchText = ""
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 300)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            fetchExplorePosts()
        }
    }
    
    func fetchExplorePosts() {
        Task {
            await fetchExplorePosts()
        }
    }
    
    @MainActor
    func fetchExplorePosts() async {
        isLoading = true
        
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
                
                let currentUsername = authVM.currentUser?.username ?? ""
                var fetchedPosts: [BlogPost] = []
                
                for postData in postsArray {
                    if let username = postData["username"] as? String,
                       let caption = postData["caption"] as? String,
                       username != currentUsername { // Exclude your own posts from explore
                        
                        // Get real image URL or use placeholder
                        let imageUrl = postData["image_url"] as? String ?? ""
                        let postId = postData["post_id"] as? Int ?? 0
                        
                        // Debug line to see what images we're getting
                        print("🔍 Debug Explore: username=\(username), imageUrl='\(imageUrl)'")
                        
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
                print("✅ Loaded \(fetchedPosts.count) posts in explore (excluding your own)")
            } else {
                print("No posts found or invalid response")
                self.posts = []
            }
        } catch {
            print("Error fetching explore posts: \(error)")
        }
        
        isLoading = false
    }
}

#Preview {
    ExploreView()
}
