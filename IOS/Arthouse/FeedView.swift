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
    @State private var posts = [
        Post(id: 1, username: "artlover22", userImage: "person.circle.fill", postImage: "sunset_photo", likes: 122),
        Post(id: 2, username: "creative_mind", userImage: "person.circle.fill", postImage: "art_photo", likes: 88)
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
                        Text("Explore")
                            .font(.system(size: 23, weight: .semibold)) 
                            .foregroundColor(.black)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("Back button tapped")
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .padding(12)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                }
                
                // Floating button and tab bar placeholder
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.blue.opacity(0.9))
                                .frame(height: 90)
                                .padding(.horizontal)
                                .shadow(radius: 4)
                            
                            HStack(spacing: 50) {
                                Button(action: {
                                    print("Home Feed Button Tapped")
                                }){
                                    Image(systemName: "house")
                                }
                                
                                Button(action: { 
                                    print("Explore Feed Button Tapped")
                                }) {
                                    Image(systemName: "magnifyingglass")
                                }
                                VStack {
                                    Button(action: {
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
                                }
                                .offset(y: -32)
                                Button(action: { 
                                    print("Notification Button Tapped")
                                }) {
                                    Image(systemName: "bell")
                                }
                                
                                Button(action: { 
                                    print("Profile Button Tapped")
                                }) {
                                    Image(systemName: "person")
                                }
                            }
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            Spacer()
                        }
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
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Name")
                        .font(.system(size: 20, weight: .bold))
                    Text("@\(post.username)")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            ZStack(alignment: .bottomLeading) {
                Image(post.postImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 260)
                    .clipped()
                    .cornerRadius(20)
                
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                    Text("\(post.likes)")
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
    FeedView()
}
