//
//  FeedView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//
import SwiftUI

struct FeedView: View {
    @State private var posts = [
        Post(id: 1, username: "artlover22", userImage: "person.circle.fill", postImage: "sunset_photo", likes: 122),
        Post(id: 2, username: "creative_mind", userImage: "person.circle.fill", postImage: "art_photo", likes: 88)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posts) { post in
                            PostCard(post: post)
                        }
                        Spacer(minLength: 80) // spacing for tab bar
                    }
                    .padding(.top, 8)
                }
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("Back tapped")
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .medium))
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                }

                // Floating button and tab bar placeholder
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 50) {
                            Image(systemName: "house")
                            Image(systemName: "magnifyingglass")
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 5)

                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            Image(systemName: "bell")
                            Image(systemName: "person")
                        }
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: - Post Model
struct Post: Identifiable {
    let id: Int
    let username: String
    let userImage: String
    let postImage: String
    let likes: Int
}

// MARK: - Post Card
struct PostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: post.userImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Name")
                        .font(.system(size: 14, weight: .bold))
                    Text("@\(post.username)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            ZStack(alignment: .bottomLeading) {
                Image(post.postImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(20)
                
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                    Text("\(post.likes)")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(12)
                .padding(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 10)
    }
}
