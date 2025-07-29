//
//  SignUpView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct SignUpView: View {
    // MARK: – State
    @EnvironmentObject var authViewModel: AuthViewModel  // injected view model
    @State private var fullName        = ""
    @State private var email           = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var username        = ""
    @State private var isLoading       = false
    @State private var errorMessage    = ""
    @Binding var showSignIn: Bool

    // height of the bottom panel
    private let bottomPanelHeight: CGFloat = 100

    var body: some View {
        ZStack {
            // 1) White background
            Color.white
                .ignoresSafeArea()

            // 2) Bottom curved panel behind everything
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(red: 0.52, green: 0.67, blue: 0.96))
                    .frame(height: bottomPanelHeight)
                    .ignoresSafeArea(edges: .bottom)
            }
            .zIndex(0)

            // 3) Main content
            VStack(spacing: 0) {
                // Back arrow
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

                // Title & subtitle
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

                // Form fields
                VStack(spacing: 20) {
                    field(
                        title: "Your Full Name",
                        placeholder: "your name",
                        text: $fullName
                    )
                    field(
                        title: "Your Email",
                        placeholder: "type your email @gmail.com",
                        text: $email,
                        keyboard: .emailAddress
                    )
                    field(
                        title: "Password",
                        placeholder: "type your password",
                        text: $password,
                        isSecure: true
                    )
                    field(
                        title: "Confirm your Password",
                        placeholder: "retype your password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                    field(
                        title: "Username",
                        placeholder: "type your username",
                        text: $username
                    )
                }
                .padding(.horizontal, 24)

                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                // Join Now button
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

                // Already have an account?
                Button("Already have an account? Sign In") {
                    showSignIn = false
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .padding(.top, 20)

                // Terms text
                Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 12))
                    .foregroundColor(Color.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                Spacer()
            }
            // lifts content above the bottom panel
            .padding(.bottom, bottomPanelHeight)
            .zIndex(1)
        }
    }

    // MARK: – Field builder
    @ViewBuilder
    private func field(
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

    // MARK: – Actions
    private func createAccount() {
        // basic validation
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

        // simulate signup
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
