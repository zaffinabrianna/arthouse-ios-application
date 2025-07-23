//
//  FeedView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct FeedView: View {
    @State private var posts = [
        Post(id: 1, username: "artlover22", userImage: "person.circle.fill", postImage: "sunset", likes: 122, caption: "Beautiful sunset today"),
        Post(id: 2, username: "creative_mind", userImage: "person.circle.fill", postImage: "mountain", likes: 89, caption: "Mountain vibes"),
        Post(id: 3, username: "photo_ninja", userImage: "person.circle.fill", postImage: "ocean", likes: 245, caption: "Ocean blues"),
        Post(id: 4, username: "art_daily", userImage: "person.circle.fill", postImage: "forest", likes: 167, caption: "Into the woods")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Posts
                    ForEach(posts) { post in
                        PostCard(post: post)
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: open camera
                        print("Camera tapped")
                    }) {
                        Image(systemName: "camera")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

// Simple Post model
struct Post: Identifiable {
    let id: Int
    let username: String
    let userImage: String
    let postImage: String
    let likes: Int
    let caption: String
}

// Post card component
struct PostCard: View {
    let post: Post
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // User header
            HStack {
                Image(systemName: post.userImage)
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                
                Text(post.username)
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                Button(action: {
                    print("More options for \(post.username)")
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Post image - using placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    // placeholder image
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                )
            
            // Interaction buttons
            HStack(spacing: 16) {
                Button(action: {
                    isLiked.toggle()
                    print("Liked post by \(post.username)")
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isLiked ? .red : .black)
                }
                
                Button(action: {
                    print("Comment on post")
                }) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    print("Share post")
                }) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Likes count
            Text("\(post.likes + (isLiked ? 1 : 0)) likes")
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Caption
            Text(post.caption)
                .font(.system(size: 14))
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom, 20)
        }
    }
}
