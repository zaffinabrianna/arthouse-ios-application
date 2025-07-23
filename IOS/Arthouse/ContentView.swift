//
//  ContentView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSignUp = false
    @State private var selectedTab = 0
    @State private var showUploadView = false
    
    var body: some View {
        if authViewModel.isLoggedIn {
            // Main app with tab navigation
            ZStack {
                TabView(selection: $selectedTab) {
                    // Feed/Explore Tab
                    FeedView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    // Search Tab (placeholder)
                    Text("Search Page\n(TODO: implement)")
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(1)
                    
                    // Upload Tab (special handling)
                    Text("")
                        .tabItem {
                            Image(systemName: "plus.square.fill")
                            Text("Upload")
                        }
                        .tag(2)
                    
                    // Notifications Tab (placeholder)
                    Text("Notifications\n(TODO: implement)")
                        .tabItem {
                            Image(systemName: "bell.fill")
                            Text("Notifications")
                        }
                        .tag(3)
                    
                    // Profile Tab
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(4)
                }
                .onChange(of: selectedTab) { newValue in
                    if newValue == 2 {
                        // Show upload view when plus tab is tapped
                        showUploadView = true
                        // Reset tab to previous
                        selectedTab = 0
                    }
                }
            }
            .sheet(isPresented: $showUploadView) {
                UploadView()
            }
        } else {
            // Authentication screens
            if showSignUp {
                SignUpView(showSignIn: $showSignUp)
                    .environmentObject(authViewModel)
            } else {
                SignInView(showSignUp: $showSignUp)
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
