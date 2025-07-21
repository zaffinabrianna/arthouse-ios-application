//
//  SignInView.swift
//  
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
        VStack(spacing: 20) {
            // TODO: add proper background later
            
            Spacer()
            
            // app name
            Text("ArtHouse")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Enter your information to sign in")
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            // username input
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Username")
                    .fontWeight(.medium)
                
                TextField("your username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
            }
            
            // password input
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .fontWeight(.medium)
                
                SecureField("enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // show error if login fails
            if !errorMsg.isEmpty {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // login button
            Button(action: {
                handleLogin()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isLoading)
            
            Text("or")
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            
            // sign up link
            Button("Sign Up Now") {
                showSignUp = true
            }
            .foregroundColor(.blue)
            
            Spacer()
            
            // terms text
            Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 30)
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
