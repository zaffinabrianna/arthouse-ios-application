//
//  PostDetailView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/9/25.
//

import SwiftUI

// MARK: – Model for Comments
struct Comment: Identifiable {
    let id: Int
    let username: String
    let content: String
}

struct PostDetailView: View {
    let post: BlogPost

    @State private var comments: [Comment] = [
        .init(id: 1, username: "user123",      content: "Text text text text"),
        .init(id: 2, username: "artist_lover", content: "Text text text text"),
        .init(id: 3, username: "coolguy",      content: "Text text text text"),
        .init(id: 4, username: "catmom",       content: "Text text text text")
    ]
    @State private var isFollowing = false
    @State private var isLiked     = false
    @State private var commentText = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        // Add navigation dismiss logic here if needed
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)

                // Post card
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
                    .padding(.horizontal)

                    // Handle missing image gracefully
                    Group {
                        if let uiImage = UIImage(named: post.imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .clipped()
                                .cornerRadius(20)
                        } else {
                            // Fallback placeholder
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

                // Comment list
                ScrollView {
                    VStack(spacing: 0) {
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
                        }
                    }
                    .padding(.bottom, 80)
                }
            }

            // Reply bar & tab bar
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
                        comments.append(.init(
                            id: comments.count + 1,
                            username: "you",
                            content: commentText
                        ))
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

                // Custom tab bar shape - temporary placeholder
                Rectangle()
                    .fill(Color.blue.opacity(1))
                    .frame(height: 90)
                    .cornerRadius(20)
                    .padding([.horizontal], -10)
                    .shadow(radius: 4)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}

// MARK: – Preview
struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(
            post: BlogPost(
                id: UUID(),
                authorName: "Demo User",
                authorHandle: "@demo",
                imageName: "sunset_photo",
                likeCount: 122,
                caption: "Demo caption for preview"

            )
        )
    }
}
