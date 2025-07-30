//
//  AppTabView.swift
//  Arthouse
//
//  Created on 7/25/25.
//

import SwiftUI

// Extension to hide tab bar
extension View {
    func hideTabBar() -> some View {
        self
            .onAppear {
                let tabBar = UITabBar.appearance()
                tabBar.isHidden = true
            }
    }
}

struct AppTabView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var showSignUp = false
    @State private var selectedTab = 0
    @State private var showUpload = false

    var body: some View {
        if authVM.isLoggedIn {
            ZStack {
                TabView(selection: $selectedTab) {
                    // 1) Feed tab
                    NavigationStack {
                        FeedView(selectedTab: $selectedTab, showUpload: $showUpload)
                    }
                    .tabItem {
                        Image(systemName: "house.fill"); Text("Home")
                    }
                    .tag(0)

                    // 2) Explore/Search
                    NavigationStack {
                        ExploreView()
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass"); Text("Explore")
                    }
                    .tag(1)

                    // 3) Upload (dummy tab triggers sheet)
                    Color.clear
                        .tabItem {
                            Image(systemName: "plus.circle.fill"); Text("Upload")
                        }
                        .tag(2)
                        .onAppear {
                            showUpload = true
                            selectedTab = 0
                        }

                    // 4) Notifications
                    NavigationStack {
                        NotificationsView()
                    }
                    .tabItem {
                        Image(systemName: "bell.fill"); Text("Notifications")
                    }
                    .tag(3)

                    // 5) Profile
                    NavigationStack {
                        ProfileView()
                    }
                    .tabItem {
                        Image(systemName: "person.fill"); Text("Profile")
                    }
                    .tag(4)
                }
                .hideTabBar() // Use our custom extension
                
                // Custom tab bar overlay - appears on all views
                VStack(spacing: 0) {
                    Spacer()
                    ZStack {
                        // Custom tab shape with cutout
                        CustomTabShape()
                            .fill(Color(red: 76/255, green: 139/255, blue: 245/255)) // Match the lighter blue
                            .frame(height: 120) // Increased height to reach bottom
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                        
                        // Tab bar icons
                        HStack {
                            // Left side icons
                            HStack(spacing: 40) {
                                Button(action: {
                                    selectedTab = 0
                                    print("Home Feed Button Tapped")
                                }){
                                    VStack(spacing: 4) {
                                        Image(systemName: "house.fill")
                                            .font(.system(size: 22))
                                        Text("Home")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 1
                                    print("Explore Feed Button Tapped")
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 22))
                                        Text("Explore")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.6))
                                }
                            }
                            
                            // Center spacer for floating button
                            Spacer()
                                .frame(width: 80)
                            
                            // Right side icons
                            HStack(spacing: 40) {
                                Button(action: {
                                    selectedTab = 3
                                    print("Notification Button Tapped")
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "bell.fill")
                                            .font(.system(size: 22))
                                        Text("Notifications")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(selectedTab == 3 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 4
                                    print("Profile Button Tapped")
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 22))
                                        Text("Profile")
                                            .font(.system(size: 10))
                                    }
                                    .foregroundColor(selectedTab == 4 ? .white : .white.opacity(0.6))
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20) // Push icons up from bottom
                        
                        // Floating upload button in the cutout
                        Button(action: {
                            showUpload = true
                            print("Post Button Tapped")
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                                
                                Circle()
                                    .fill(Color(red: 76/255, green: 139/255, blue: 245/255)) // Match the lighter blue
                                    .frame(width: 55, height: 55)
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28, weight: .bold))
                            }
                        }
                        .offset(y: -45) // Adjusted for new height
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .environmentObject(authVM)
            .sheet(isPresented: $showUpload) {
                UploadView()
                    .environmentObject(authVM)
            }

        } else {
            // Not logged in: show sign in / sign up
            if showSignUp {
                SignUpView(showSignIn: $showSignUp)
                    .environmentObject(authVM)
            } else {
                SignInView(showSignUp: $showSignUp)
                    .environmentObject(authVM)
            }
        }
    }
}

// MARK: - Preview
struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
