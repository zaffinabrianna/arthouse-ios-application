//
//  PostDetailView.swift
//  Arthouse
//
//  Created on 7/9/25.
//

import SwiftUI

// Comment model for the comment section
struct Comment: Identifiable {
    let id: Int
    let username: String
    let content: String
}

struct PostDetailView: View {
    let post: BlogPost
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel

    @State private var comments: [Comment] = [
        .init(id: 1, username: "user123",      content: "Text text text text"),
        .init(id: 2, username: "artist_lover", content: "Text text text text"),
        .init(id: 3, username: "coolguy",      content: "Text text text text"),
        .init(id: 4, username: "catmom",       content: "Text text text text")
    ]
    @State private var isFollowing = false
    @State private var isLiked     = false
    @State private var commentText = ""
    @State private var showDeleteAlert = false
    @State private var isDeleting = false
    
    // Check if this post belongs to the current user
    var isOwnPost: Bool {
        let result = post.authorHandle == "@\(authVM.currentUser?.username ?? "")"
        print("🔍 Debug: post.authorHandle = '\(post.authorHandle)'")
        print("🔍 Debug: current user = '@\(authVM.currentUser?.username ?? "")'")
        print("🔍 Debug: isOwnPost = \(result)")
        print("🔍 Debug: postId = \(post.postId)")
        return result
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with back and delete buttons
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Only show delete button if it's your post
                    if isOwnPost {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(.red)
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(isDeleting)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .background(Color.white)

                // Main post content
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(post.authorName)
                                .font(.system(size: 18, weight: .bold))
                            Text(post.authorHandle)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Show follow button only for other people's posts
                        if !isOwnPost {
                            Button {
                                isFollowing.toggle()
                            } label: {
                                Text(isFollowing ? "Following" : "Follow")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 14)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Show the post image
                    Group {
                        if !post.imageName.isEmpty && post.imageName != "placeholder_image" {
                            // Load real image from URL
                            AsyncImage(url: URL(string: post.imageName)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                    )
                            }
                            .frame(maxHeight: 300)
                            .cornerRadius(20)
                        } else {
                            // Show placeholder when no image
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 260)
                                .cornerRadius(20)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        Text("Image not found")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                    }
                    .padding(.horizontal)

                    // Show the caption if there is one
                    if !post.caption.isEmpty {
                        Text(post.caption)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }

                    // Like button and count
                    HStack(spacing: 6) {
                        Button {
                            isLiked.toggle()
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .black)
                        }
                        Text("\(post.likeCount)")
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.vertical)
                .background(Color(red: 0.92, green: 0.95, blue: 1.0))
                .cornerRadius(30)
                .padding(.horizontal)
                .padding(.bottom, 10)

                // Comments section with scroll reader to fix scrolling bug
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(comments) { comment in
                                VStack(spacing: 6) {
                                    HStack(alignment: .top, spacing: 10) {
                                        Circle()
                                            .fill(Color.gray.opacity(0.4))
                                            .frame(width: 36, height: 36)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            HStack {
                                                Text("Name")
                                                    .font(.system(size: 15, weight: .bold))
                                                Text("@\(comment.username)")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 14))
                                            }
                                            Text(comment.content)
                                                .font(.system(size: 15))
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    Divider()
                                        .padding(.leading, 60)
                                }
                                .padding(.horizontal)
                                .id(comment.id) // Need this for scroll tracking
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    .onChange(of: comments.count) { _ in
                        // When new comment added, scroll to show it
                        if let lastComment = comments.last {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(lastComment.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            // Comment input and bottom area
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 32, height: 32)

                    TextField("Write a reply", text: $commentText)
                        .padding(10)
                        .background(Color(red: 0.8, green: 0.88, blue: 1.0))
                        .cornerRadius(20)

                    Button {
                        guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        
                        // Create new comment with unique ID
                        let newComment = Comment(
                            id: (comments.max(by: { $0.id < $1.id })?.id ?? 0) + 1,
                            username: "you",
                            content: commentText
                        )
                        
                        comments.append(newComment)
                        commentText = ""
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.white)

                // Space for the tab bar
                Color.clear
                    .frame(height: 90)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
        .alert("Delete Post", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deletePost()
            }
        } message: {
            Text("Are you sure you want to delete this post? This action cannot be undone.")
        }
    }
    
    // Handle deleting the post
    func deletePost() {
        guard let currentUser = authVM.currentUser else { return }
        
        isDeleting = true
        
        // Use the real post ID from database
        let postId = post.postId
        
        guard let url = URL(string: "http://localhost:5001/api/posts/\(postId)") else {
            isDeleting = false
            return
        }
        
        let deleteData = ["username": currentUser.username]
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: deleteData)
        } catch {
            print("Couldn't package delete request")
            isDeleting = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isDeleting = false
                
                if let error = error {
                    print("❌ Delete failed: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Delete failed: Bad response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("✅ Post deleted successfully")
                    // Go back to previous screen
                    self.dismiss()
                } else {
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let message = json["error"] as? String {
                        print("❌ Delete failed: \(message)")
                    } else {
                        print("❌ Delete failed: HTTP \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }
}
