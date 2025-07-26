//
//  NotificationsView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//


import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                // Placeholder content
                VStack(spacing: 20) {
                    Image(systemName: "bell.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No notifications yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("When you get notifications, they'll appear here")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
