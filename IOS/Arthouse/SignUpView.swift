//
//  SignUpView.swift
//  Arthouse
//
//  Created on 7/21/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullName        = ""
    @State private var email           = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var username        = ""
    @State private var isLoading       = false
    @State private var errorMessage    = ""
    @Binding var showSignIn: Bool

    // Height for the blue bottom section
    private let bottomPanelHeight: CGFloat = 100

    var body: some View {
        ZStack {
            // White background
            Color.white
                .ignoresSafeArea()

            // Blue curved section at bottom
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(red: 0.52, green: 0.67, blue: 0.96))
                    .frame(height: bottomPanelHeight)
                    .ignoresSafeArea(edges: .bottom)
            }
            .zIndex(0)

            // Main signup form
            VStack(spacing: 0) {
                // Back button
                HStack {
                    Button { showSignIn = false } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom, 20)

                // App title and signup text
                VStack(spacing: 8) {
                    Text("ArtHouse")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Text("Create an Account")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    Text("Enter your information to sign up")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 30)

                // All the input fields
                VStack(spacing: 20) {
                    inputField(
                        title: "Your Full Name",
                        placeholder: "your name",
                        text: $fullName
                    )
                    inputField(
                        title: "Your Email",
                        placeholder: "type your email @gmail.com",
                        text: $email,
                        keyboard: .emailAddress
                    )
                    inputField(
                        title: "Password",
                        placeholder: "type your password",
                        text: $password,
                        isSecure: true
                    )
                    inputField(
                        title: "Confirm your Password",
                        placeholder: "retype your password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                    inputField(
                        title: "Username",
                        placeholder: "type your username",
                        text: $username
                    )
                }
                .padding(.horizontal, 24)

                // Show any error messages
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                // Sign up button
                Button(action: createAccount) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Join Now")
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(red: 0.52, green: 0.67, blue: 0.96))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .disabled(isLoading)

                // Link back to sign in
                Button("Already have an account? Sign In") {
                    showSignIn = false
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .padding(.top, 20)

                // Terms and privacy text
                Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                Spacer()
            }
            // Push content up above the blue bottom section
            .padding(.bottom, bottomPanelHeight)
            .zIndex(1)
        }
    }

    // Helper function to build input fields
    @ViewBuilder
    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)

            Group {
                if isSecure {
                    SecureField("", text: text, prompt:
                        Text(placeholder)
                            .foregroundColor(Color.gray.opacity(0.6))
                    )
                    .textContentType(.none)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                } else {
                    TextField("", text: text, prompt:
                        Text(placeholder)
                            .foregroundColor(Color.gray.opacity(0.6))
                    )
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(username.isEmpty ? .none : .username)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }

    // Handle account creation
    private func createAccount() {
        // Check if all fields are filled out
        if fullName.isEmpty ||
           email.isEmpty ||
           password.isEmpty ||
           confirmPassword.isEmpty ||
           username.isEmpty
        {
            errorMessage = "Please fill in all fields"
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords don't match"
            return
        }

        isLoading    = true
        errorMessage = ""

        // Call the signup function
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            authViewModel.signup(name: fullName,
                                 email: email,
                                 password: password)
            isLoading = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignIn: .constant(false))
            .environmentObject(AuthViewModel())
    }
}
