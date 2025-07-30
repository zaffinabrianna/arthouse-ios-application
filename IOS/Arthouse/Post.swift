//
//  Post.swift
//  Arthouse
//
//  Created on 7/25/25.
//

import Foundation

struct BlogPost: Identifiable, Hashable {
    let id: UUID                 // SwiftUI needs this for lists
    let postId: Int             // Real database ID for deleting posts
    let authorName: String      // User's display name like "Roberto"
    let authorHandle: String    // Username with @ like "@roberto"
    let imageName: String       // Either image URL from server or local asset name
    let likeCount: Int          // How many likes the post has
    let caption: String         // What the user wrote about their post
}
