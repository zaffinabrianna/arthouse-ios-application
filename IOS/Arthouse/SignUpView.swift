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
        ZStack {
            // White background
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section with back button
                HStack {
                    Button(action: {
                        print("Going back to sign in")
                        showSignIn = true
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .font(.system(size: 22, weight: .regular))
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top, 60) // proper spacing from top
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
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
                        .padding(.bottom, 30)
                        
                        // form fields
                        VStack(spacing: 20) {
                            // full name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Full Name")
                                    .fontWeight(.semibold)
                                TextField("your name", text: $fullName)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            // email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Email")
                                    .fontWeight(.semibold)
                                TextField("type your email @gmail.com", text: $email)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            // password - FIXED: uncommented these
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .fontWeight(.semibold)
                                SecureField("type your password", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            // confirm password - FIXED: uncommented these
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm your Password")
                                    .fontWeight(.semibold)
                                SecureField("retype your password", text: $confirmPassword)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // error display
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal, 30)
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
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        
                        Text("or")
                            .foregroundColor(.gray)
                            .padding(.vertical, 10)
                        
                        // google signin
                        Button(action: {
                            // TODO: implement google signin
                            print("Google sign in tapped")
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Continue with Google")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 30)
                        
                        // back to signin
                        Button("Already have an account? Sign In") {
                            showSignIn = true
                        }
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                        
                        // terms
                        VStack(spacing: 5) {
                            Text("By clicking continue, you agree to our")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 4) {
                                Text("Terms of Service")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("and")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Privacy Policy")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
    
    func createAccount() {
        // basic validation
        if fullName.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Please fill all fields"
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords don't match"
            return
        }
        
        if password.count < 6 {
            errorMessage = "Password too short"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // fake signup process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Account created for: \(fullName)")
            // TODO: actually create account
            isLoading = false
        }
    }
}
