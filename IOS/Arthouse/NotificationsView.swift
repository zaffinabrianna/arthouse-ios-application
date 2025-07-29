//
//  NotificationsView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header - matches ExploreView exactly
                HStack {
                    Text("Notifications")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Centered content - matches ExploreView structure
                        VStack(spacing: 16) {
                            Image(systemName: "bell.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No notifications yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("When you get notifications, they'll appear here")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 100)
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.top, -10)
                }
            }
        }
    }
}
