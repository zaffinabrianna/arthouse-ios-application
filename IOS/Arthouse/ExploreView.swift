//
//  ExploreView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import SwiftUI

// MARK: – Model
struct ExplorePost: Identifiable {
    let id: Int
    let userName: String
    let userHandle: String
    let imageName: String
    let likeCount: Int
}

// MARK: – ExploreView
struct ExploreView: View {
    // dummy data; swap in your real recommendations later
    let posts: [ExplorePost] = [
        .init(id: 1, userName: "Name", userHandle: "@Username",
              imageName: "sunset_photo", likeCount: 122),
        .init(id: 2, userName: "Name", userHandle: "@Username",
              imageName: "art_photo", likeCount: 87)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                // Camera button
                Button(action: {
                    // camera action
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Explore")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Search button
                Button(action: {
                    // navigate to search screen
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(posts) { post in
                        ExploreCardView(post: post)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .background(Color(white: 0.95).ignoresSafeArea())
        }
    }
}

// MARK: – Card
private struct ExploreCardView: View {
    let post: ExplorePost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User header
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.userName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(post.userHandle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            // Image
            Image(post.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(16)
            
            // Likes
            HStack(spacing: 6) {
                Image(systemName: "heart")
                Text("\(post.likeCount)")
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)
        }
        .padding()
        .background(Color(red: 0.92, green: 0.95, blue: 1.0))
        .cornerRadius(24)
    }
}

// MARK: – Preview
struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
