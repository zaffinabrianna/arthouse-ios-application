//
//  ExploreView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import SwiftUI

struct ExploreView: View {
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
            likeCount: 87
        ),
        BlogPost(
            id: UUID(),
            authorName: "Photo Master",
            authorHandle: "@photomaster",
            imageName: "nature_pic",
            likeCount: 156
        ),
        BlogPost(
            id: UUID(),
            authorName: "Digital Artist",
            authorHandle: "@digitalart",
            imageName: "abstract_art",
            likeCount: 203
        )
    ]
    
    @State private var showingSearch = false
    @State private var searchText = ""
    
    var filteredPosts: [BlogPost] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { post in
                post.authorName.localizedCaseInsensitiveContains(searchText) ||
                post.authorHandle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Explore")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSearch = true
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                        Spacer(minLength: 120)
                    }
                    .padding(.top, -10)
                }
            }
            
            // Search Overlay
            if showingSearch {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingSearch = false
                        searchText = ""
                    }
                
                VStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search users...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Button("Cancel") {
                            showingSearch = false
                            searchText = ""
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                    
                    // Search Results
                    if !searchText.isEmpty {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(filteredPosts) { post in
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .foregroundColor(.gray)
                                            .frame(width: 40, height: 40)
                                        
                                        VStack(alignment: .leading) {
                                            Text(post.authorName)
                                                .font(.headline)
                                            Text(post.authorHandle)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        showingSearch = false
                                        searchText = ""
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 300)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
