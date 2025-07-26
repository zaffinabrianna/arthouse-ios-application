//
//  Post.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import Foundation

struct BlogPost: Identifiable, Hashable {
    let id: UUID
    let authorName: String     // e.g. "Name"
    let authorHandle: String   // e.g. "@Username"
    let imageName: String      // must match an asset in your catalog
    let likeCount: Int
}
