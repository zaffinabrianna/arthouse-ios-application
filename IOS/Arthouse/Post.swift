//
//  Post.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import Foundation

struct BlogPost: Identifiable, Hashable {
    let id: UUID
    let postId: Int           // NEW: Database post ID for deletion
    let authorName: String    // e.g. "Name"
    let authorHandle: String  // e.g. "@Username"
    let imageName: String     
    let likeCount: Int
    let caption: String       // The post caption/description
}
