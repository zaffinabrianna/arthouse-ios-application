//
//  SignInView.swift
//  Arthouse
//
//  Created on 7/21/25.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username     = ""
    @State private var email        = ""
    @State private var password     = ""
    @State private var isLoading    = false
    @State private var errorMsg     = ""
    @Binding var showSignUp: Bool

    // Height for the blue bottom section
    private let bottomPanelHeight: CGFloat = 100

    var body: some View {
        ZStack {
            // White background
            Color.white
                .ignoresSafeArea()

            // Blue curved section at bottom
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(red: 0.52, green: 0.67, blue: 0.96))
                .frame(height: bottomPanelHeight)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
                .zIndex(0)

            // Main login form
            VStack(spacing: 0) {
                // App title and login text
                VStack(spacing: 8) {
                    Text("ArtHouse")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Text("Enter your information to sign in")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                .padding(.top, 60)

                // Login input fields
                VStack(spacing: 20) {
                    inputField(title: "Your Username",
                          placeholder: "your username",
                          text: $username)

                    inputField(title: "Your Email",
                          placeholder: "you@example.com",
                          text: $email,
                          keyboard: .emailAddress)

                    inputField(title: "Password",
                          placeholder: "enter password",
                          text: $password,
                          isSecure: true)
                }
                .padding(.top, 32)
                .padding(.horizontal, 24)

                // Show any error messages
                if !errorMsg.isEmpty {
                    Text(errorMsg)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                // Login button
                Button(action: handleLogin) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Login")
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

                // Divider with "or" text
                HStack(alignment: .center) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.3))
                    Text(" or ")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray.opacity(0.7))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.3))
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                // Sign up button
                Button(action: { showSignUp = true }) {
                    Text("Sign Up Now")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Terms and privacy text
                Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                Spacer()
            }
            .padding(.bottom, bottomPanelHeight)
            .zIndex(1)

            // Listen for login status changes
            .onReceive(authViewModel.$errorMessage) { newError in
                if let newError = newError {
                    errorMsg = newError
                }
            }
            .onReceive(authViewModel.$isLoggedIn) { loggedIn in
                if loggedIn {
                    errorMsg = ""
                }
            }
        }
    }

    // Helper function to build input fields
    @ViewBuilder
    private func inputField(title: String,
                       placeholder: String,
                       text: Binding<String>,
                       isSecure: Bool = false,
                       keyboard: UIKeyboardType = .default) -> some View {
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
                } else {
                    TextField("", text: text, prompt:
                        Text(placeholder)
                            .foregroundColor(Color.gray.opacity(0.6))
                    )
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
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

    // Handle user login
    private func handleLogin() {
        guard !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            errorMsg = "Please fill in all fields"
            return
        }

        isLoading = true
        errorMsg = ""

        authViewModel.login(username: username, password: password)

        // Wait for the login process to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showSignUp: .constant(false))
            .environmentObject(AuthViewModel())
    }
}
