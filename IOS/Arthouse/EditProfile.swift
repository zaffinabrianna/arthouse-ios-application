//
//  EditProfile.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//

import SwiftUI

struct EditProfile: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isFollowing = false
    @State private var followerCount = 100
    @State private var followingCount = 342
    @State private var username: String = ""
    @State private var bio = "This is where the user writes their bio"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Done button tapped - saving changes")
                        dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .zIndex(2)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 180)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 200) {
                            VStack(spacing: 4) {
                                Text("\(followerCount)")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                Text("Followers")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(followingCount)")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                Text("Following")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Your Username")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            
                            TextField("Enter username", text: $username)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Your Bio")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            
                            TextEditor(text: $bio)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.bottom, 25)
                        }
                        
                        Button(action: {
                            authVM.logout()
                        }) {
                            Text("Sign Out")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            print("Delete account tapped")
                        }) {
                            Text("Delete Account")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.top, 80)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.7))
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
                .zIndex(1)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 50))
                    )
                    .offset(y: 130)
                    .zIndex(3)
            }
        }
        .onAppear {
            username = "@\(authVM.currentUser?.username ?? "username")"
        }
    }
}

#Preview {
    EditProfile()
}
