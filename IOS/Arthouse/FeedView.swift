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
        NavigationView {
            ZStack {
                Color(.white).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posts) { post in
                            PostCard(post: post)
                        }
                        Spacer(minLength: 80) // spacing for tab bar
                    }
                    .padding(.top, 8)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Feed")
                            .font(.system(size: 23, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                // Floating button and tab bar placeholder
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack{
                            // Temporary placeholder for CustomTabShape
                            Rectangle()
                                .fill(Color.blue.opacity(1))
                                .frame(height: 90)
                                .cornerRadius(20)
                                .padding(.horizontal, -10)
                                .shadow(radius: 4)
                            
                            //Icon Section
                            HStack(spacing: 50) {
                                Button(action: {
                                    selectedTab = 0
                                    print("Home Feed Button Tapped")
                                }){
                                    Image(systemName: "house.fill")
                                        .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 1
                                    print("Explore Feed Button Tapped")
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.6))
                                }
                                
                                Spacer().frame(width: 60)
                                
                                Button(action: {
                                    selectedTab = 3
                                    print("Notification Button Tapped")
                                }) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(selectedTab == 3 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 4
                                    print("Profile Button Tapped")
                                }) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(selectedTab == 4 ? .white : .white.opacity(0.6))
                                }
                            }
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            
                            Button(action: {
                                showUpload = true
                                print("Post Button Tapped")
                            }){
                                ZStack{
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 5)
                                    Image(systemName: "plus")
                                        .foregroundColor(.navy)
                                        .font(.system(size: 27, weight: .bold))
                                }
                            }
                            .offset(y: -15)
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)

                    }
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: BlogPost
    
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
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                    Text("\(post.likeCount)")
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
