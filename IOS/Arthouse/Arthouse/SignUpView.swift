//
//  SignUpView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @Binding var showSignIn: Bool
    
    var body: some View {
        ScrollView { // need scroll for smaller screens
            VStack(spacing: 20) {
                
                Spacer().frame(height: 50) // push content down a bit
                
                // header
                Text("ArtHouse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 5) {
                    Text("Create an Account")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Enter your information to sign up for this app")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 20)
                
                // form fields
                VStack(spacing: 16) {
                    // full name
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your Full Name")
                            .fontWeight(.semibold)
                        TextField("your name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // email
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your Email")
                            .fontWeight(.semibold)
                        TextField("type your email @gmail.com", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    // password
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .fontWeight(.semibold)
                        SecureField("type your password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // confirm password
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirm your Password")
                            .fontWeight(.semibold)
                        SecureField("retype your password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // error display
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // join button
                Button(action: {
                    createAccount()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(isLoading ? "Creating..." : "Join Now")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isLoading)
                .padding(.top, 10)
                
                Text("or")
                    .foregroundColor(.gray)
                
                // google signin - placeholder for now
                Button(action: {
                    // TODO: implement google signin
                    print("Google sign in tapped")
                }) {
                    HStack {
                        Image(systemName: "globe") // using system icon for now
                        Text("Continue with Google")
                            .fontWeight(.medium)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(10)
                
                // back to signin
                Button("Already have an account? Sign In") {
                    showSignIn = true
                }
                .foregroundColor(.blue)
                .padding(.top, 10)
                
                // terms
                VStack(spacing: 2) {
                    Text("By clicking continue, you agree to our")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // TODO: make these actual links later
                    HStack {
                        Text("Terms of Service").fontWeight(.medium)
                        Text("and").foregroundColor(.gray)
                        Text("Privacy Policy").fontWeight(.medium)
                    }
                    .font(.caption)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                
                Spacer().frame(height: 50)
            }
            .padding(.horizontal, 30)
        }
    }
    
    func createAccount() {
        // basic validation - could be better
        if fullName.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Please fill all fields"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords don't match"
            return
        }
        
        if password.count < 6 { // basic password check
            errorMessage = "Password too short"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // fake signup process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Account created for: \(fullName)")
            // TODO: actually create account and navigate
            isLoading = false
        }
    }
}
