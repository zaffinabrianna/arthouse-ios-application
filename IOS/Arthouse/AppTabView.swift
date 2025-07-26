//
//  AppTabView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
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
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack{
                            // Custom tab shape
                            Rectangle()
                                .fill(Color.blue.opacity(1))
                                .frame(height: 90)
                                .cornerRadius(20)
                                .padding(.horizontal, -10)
                                .shadow(radius: 4)
                            
                            //Icon Section
                            HStack(spacing: 50) {
                                Button(action: {
                                    selectedTab = 0
                                    print("Home Feed Button Tapped")
                                }){
                                    Image(systemName: "house.fill")
                                        .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 1
                                    print("Explore Feed Button Tapped")
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.6))
                                }
                                
                                Spacer().frame(width: 60)
                                
                                Button(action: {
                                    selectedTab = 3
                                    print("Notification Button Tapped")
                                }) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(selectedTab == 3 ? .white : .white.opacity(0.6))
                                }
                                
                                Button(action: {
                                    selectedTab = 4
                                    print("Profile Button Tapped")
                                }) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(selectedTab == 4 ? .white : .white.opacity(0.6))
                                }
                            }
                            .font(.system(size: 22))
                            .padding(.horizontal)
                            
                            Button(action: {
                                showUpload = true
                                print("Post Button Tapped")
                            }){
                                ZStack{
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 5)
                                    Image(systemName: "plus")
                                        .foregroundColor(Color(red: 0, green: 0, blue: 0.9))
                                        .font(.system(size: 27, weight: .bold))
                                }
                            }
                            .offset(y: -15)
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    }
                    .padding(.bottom, 10)
                }
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
