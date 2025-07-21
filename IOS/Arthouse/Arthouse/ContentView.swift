import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSignUp = false
    
    var body: some View {
        if authViewModel.isLoggedIn {
            // placeholder for main app
            VStack {
                Text("Welcome!")
                    .font(.title)
                
                if let user = authViewModel.currentUser {
                    Text("Hello, \(user.name)!")
                }
                
                Button("Logout") {
                    authViewModel.logout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        } else {
            if showSignUp {
                SignUpView(showSignIn: .constant(false))
                    .environmentObject(authViewModel)
            } else {
                SignInView(showSignUp: $showSignUp)
                    .environmentObject(authViewModel)
            }
        }
    }
}
