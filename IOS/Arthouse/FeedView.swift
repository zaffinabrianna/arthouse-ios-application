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
    @State private var posts = [
        BlogPost(
            id: UUID(),
            authorName: "Art Lover",
            authorHandle: "@artlover22",
            imageName: "sunset_photo",
            likeCount: 122
        ),
        BlogPost(
            id: UUID(),
            authorName: "Creative Mind",
            authorHandle: "@creative_mind",
            imageName: "art_photo",
            likeCount: 88
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(posts) { post in
                        PostCard(post: post)
                    }
                    Spacer(minLength: 120) // spacing for custom tab bar
                }
                .padding(.top, -20) // Pull content closer to title
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Feed")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

// MARK: - Post Card
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
            
            ZStack(alignment: .bottomLeading) {
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
                                    Text("Image: \(post.imageName)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                }
                
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
        .padding(.horizontal, 10)
    }
}

// MARK: - Preview
#Preview {
    FeedView(selectedTab: .constant(0), showUpload: .constant(false))
}
