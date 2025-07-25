//
//  ContentView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var comments = [
        Comment(id: 1, username: "user123", content: "Text text text text"),
        Comment(id: 2, username: "artist_lover", content: "Text text text text"),
        Comment(id: 3, username: "coolguy", content: "Text text text text"),
        Comment(id: 4, username: "catmom", content: "Text text text text")
    ]
    
    @State private var isFollowing = false
    @State private var isLiked = false
    @State private var commentText = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Top bar with back button
                HStack {
                    Button(action: {
                        print("Back tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .background(Color.white)
                
                // MARK: - Post content card
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Name")
                                .font(.system(size: 18, weight: .bold))
                            Text("@Username")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isFollowing.toggle()
                        }) {
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
                    
                    Image("sunset_photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .clipped()
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    HStack(spacing: 6) {
                        Button(action: {
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .black)
                        }
                        Text("122")
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.vertical)
                .background(Color(red: 0.92, green: 0.95, blue: 1.0)) // Light blue
                .cornerRadius(30)
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // MARK: - Comment list
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
                    .padding(.bottom, 80) // Space for reply + tab bar
                }
            }
            
            // MARK: - Write a reply bar
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
                    
                    Button(action: {
                        if !commentText.trimmingCharacters(in: .whitespaces).isEmpty {
                            comments.append(Comment(id: comments.count + 1, username: "you", content: commentText))
                            commentText = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.white)
                
                // MARK: - Custom tab bar
                ZStack {
                    CustomTabShape()
                        .fill(Color(red: 0.25, green: 0.45, blue: 1.0))
                        .frame(height: 90)
                        .shadow(radius: 4)
                        .overlay(
                            HStack(spacing: 50) {
                                Image(systemName: "house.fill")
                                Image(systemName: "magnifyingglass")
                                Spacer()
                                Image(systemName: "bell.fill")
                                Image(systemName: "person.fill")
                            }
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                        )
                    
                    // Center "+" button
                    Button(action: {
                        print("Post tapped")
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                                .shadow(radius: 5)
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.system(size: 26, weight: .bold))
                        }
                    }
                    .offset(y: -30)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Models
struct Comment: Identifiable {
    let id: Int
    let username: String
    let content: String
}

// MARK: - Custom Tab Shape
struct CustomTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = rect.midX
        let radius: CGFloat = 38
        let cutoutWidth: CGFloat = radius * 2
        let cutoutHeight: CGFloat = radius
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: center - cutoutWidth / 2, y: 0))
        
        path.addArc(
            center: CGPoint(x: center, y: 0),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
