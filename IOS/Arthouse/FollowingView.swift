//
//  FollowingView.swift
//  Arthouse
//
//  Created on 7/25/25.
//

import SwiftUI

struct FollowingView: View {
    @Environment(\.dismiss) private var dismiss  // Add this to dismiss the sheet
    let following = Array(repeating: "@Username", count: 12)
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Blue background
            Color(red: 0.5, green: 0.75, blue: 1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section with back button and following count
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 2) {
                        Text("100")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Following")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity)
                    
                    // Back button - now actually works
                    Button(action: {
                        dismiss()  // This will close the sheet
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                            .padding(.leading)
                    }
                    .padding(.top, 10)
                }
                
                // Main content area with rounded top corners
                ZStack {
                    Color(red: 0.9, green: 0.95, blue: 1.0)
                        .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea(edges: .bottom)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(following.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    // Profile picture circle
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Text(following[index])
                                        .fontWeight(.semibold)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 40)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
}
