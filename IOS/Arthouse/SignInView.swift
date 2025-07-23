//
//  SignInView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMsg = ""
    @Binding var showSignUp: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Blue gradient background like the mockup
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status bar area
                    HStack {
                        Text("9:41")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            // Signal bars
                            HStack(spacing: 2) {
                                Rectangle()
                                    .frame(width: 3, height: 4)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .frame(width: 3, height: 6)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .frame(width: 3, height: 8)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .frame(width: 3, height: 10)
                                    .foregroundColor(.white)
                            }
                            
                            // WiFi
                            Image(systemName: "wifi")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                            // Battery
                            Image(systemName: "battery.100")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // White content card
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Text("ArtHouse")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Enter your information to sign in")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 32)
                        
                        // Form fields
                        VStack(spacing: 20) {
                            // Username field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Username")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("your username", text: $username)
                                    .padding(16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .font(.system(size: 16))
                                    .autocapitalization(.none)
                            }
                            
                            // Email field (like in mockup - shows "Your Email" but is for password)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Email")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("type your password")
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            
                            // Password field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                SecureField("enter password", text: $password)
                                    .padding(16)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .font(.system(size: 16))
                            }
                        }
                        
                        // Error message
                        if !errorMsg.isEmpty {
                            Text(errorMsg)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }
                        
                        // Login button
                        Button(action: {
                            handleLogin()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isLoading ? "Signing In..." : "Login")
                                    .font(.system(size: 18, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        .disabled(isLoading)
                        
                        // Divider
                        Text("or")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        
                        // Sign up link
                        Button(action: {
                            showSignUp = true
                        }) {
                            Text("Sign Up Now")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        
                        // Terms text
                        Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
        }
    }
    
    // handle login logic
    func handleLogin() {
        // basic validation
        if username.isEmpty || password.isEmpty {
            errorMsg = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMsg = ""
        
        // simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // hardcoded for testing - TODO: connect to real API
            if username.lowercased() == "demo" && password == "demo" {
                print("Login successful!")
                // TODO: navigate to main app
            } else {
                errorMsg = "Invalid credentials"
            }
            isLoading = false
        }
    }
}

#Preview {
    SignInView(showSignUp: .constant(false))
}
