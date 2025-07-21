//
//  AuthViewModel.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

// basic user model
struct User {
    let username: String
    let email: String
    let name: String
}

// simple auth manager
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    
    // TODO: connect to actual backend later
    func login(username: String, password: String) {
        // mock login for now
        if username == "demo" && password == "demo" {
            currentUser = User(username: "demo", email: "demo@test.com", name: "Demo User")
            isLoggedIn = true
        }
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
    
    func signup(name: String, email: String, password: String) {
        // mock signup
        let username = name.lowercased().replacingOccurrences(of: " ", with: "")
        currentUser = User(username: username, email: email, name: name)
        isLoggedIn = true
    }
}

#Preview {
    SignInView(showSignUp: .constant(false))
}
