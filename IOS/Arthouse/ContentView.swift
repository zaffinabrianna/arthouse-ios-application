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
                
                // Floating button and tab bar placeholder
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack{
                            CustomTabShape()
                                .fill(Color.blue.opacity(0.9))
                                .frame(height: 90)
                                .padding(.horizontal, -10)
                                .shadow(radius: 4)
                            
                            //Icon Section
                            HStack(spacing: 50) {
                                Button(action: {
                                    print("Home Feed Button Tapped")
                                }){
                                    Image(systemName: "house.fill")
                                        .foregroundColor(.white)
                                }
                                
                                Button(action: { 
                                    print("Explore Feed Button Tapped")
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                }
                                
                                Spacer().frame(width: 60)
                                
                                    .offset(y: -32)
                                Button(action: { 
                                    print("Notification Button Tapped")
                                }) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.white)
                                }
                                
                                Button(action: { 
                                    print("Profile Button Tapped")
                                }) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            
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
                            .offset(y: -10)
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: - Models
struct Comment: Identifiable {
    let id: Int
    let username: String
    let content: String
}

struct CustomTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let radius: CGFloat = 38
        let cutoutDepth: CGFloat = 30
        let center = width / 2
        
        let cutoutStartX = center - radius
        let cutoutEndX = center - radius
        
        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Left straight section
        path.addLine(to: CGPoint(x: cutoutStartX, y: 0))
        
        // Circular cutout
        path.addArc(
            center: CGPoint(x: center, y: cutoutDepth),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )
        
        // Right straight section
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
