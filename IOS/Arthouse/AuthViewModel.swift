//
//  AuthViewModel.swift
//  Arthouse
//
//  Created on 7/21/25.
//

import SwiftUI
import Foundation

// User model
struct User {
    let username: String
    let email: String
    let name: String
}

// Auth manager with real API calls
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://localhost:5001/api"
    
    // Real login function
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        let loginData = [
            "username": username,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData)
        } catch {
            errorMessage = "Failed to encode login data"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let success = json["success"] as? Bool, success {
                            // Login successful
                            if let userData = json["user"] as? [String: Any],
                               let username = userData["username"] as? String,
                               let email = userData["email"] as? String,
                               let name = userData["name"] as? String {
                                
                                self?.currentUser = User(username: username, email: email, name: name)
                                self?.isLoggedIn = true
                                print("✅ Login successful for: \(username)")
                            }
                        } else {
                            // Login failed
                            self?.errorMessage = json["error"] as? String ?? "Login failed"
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
    
    // Real signup function
    func signup(name: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/register") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        let username = name.lowercased().replacingOccurrences(of: " ", with: "")
        
        let signupData = [
            "username": username,
            "email": email,
            "password": password,
            "name": name
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: signupData)
        } catch {
            errorMessage = "Failed to encode signup data"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let success = json["success"] as? Bool, success {
                            // Signup successful
                            if let userData = json["user"] as? [String: Any],
                               let username = userData["username"] as? String,
                               let email = userData["email"] as? String,
                               let name = userData["name"] as? String {
                                
                                self?.currentUser = User(username: username, email: email, name: name)
                                self?.isLoggedIn = true
                                print("✅ Signup successful for: \(username)")
                            }
                        } else {
                            // Signup failed
                            self?.errorMessage = json["error"] as? String ?? "Signup failed"
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        errorMessage = nil
        print("User logged out")
    }
}

#Preview {
    SignInView(showSignUp: .constant(false))
}
