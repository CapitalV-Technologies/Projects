//
//  LoginView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct LoginView: View {
    //Stole this code from Taskly and then updated it for my own use
    @Environment(AuthManager.self) private var authManager: AuthManager
    @Environment(NetworkManager.self) private var networkManager: NetworkManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSignup = false
    
    var body: some View {
        let padding: CGFloat = 30
        let imageWidth: CGFloat = 100
        let imageHeight: CGFloat = 100
        let buttonHeight: CGFloat = 50
        let cornerRadius: CGFloat = 12
        let opacity = 0.7
        NavigationStack {
            ZStack {
               backgroundColor.ignoresSafeArea()
                VStack(spacing: padding) {
                    Spacer()
                    VStack(spacing: padding / 3) {
                        Image("PokemonBall")
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                        Text("Pokedex")
                            .bold()
                            .font(.largeTitle)
                        Text("Sign in to continue")
                            .foregroundColor(.gray)
                    }
                    // Login Form
                    VStack(spacing: padding / 1.5) {
                        // Email Field
                        VStack(alignment: .leading, spacing: padding / 3) {
                            Text("Email:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("Enter Email", text: $email)
                                .textFieldStyle(AuthTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: padding / 3) {
                            Text("Password:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            SecureField("Enter Password", text: $password)
                                .textFieldStyle(AuthTextFieldStyle())
                        }
                        // Login Button
                        Button {
                            self.login()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Log In")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: buttonHeight)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity((isLoading || email.isEmpty || password.isEmpty) ? opacity - 0.3 : 1.0)
                        
                        // Sign Up Link
                        Button {
                            showSignup = true
                        } label: {
                            HStack(spacing: padding / 5) {
                                Text("Don't have an account?")
                                    .foregroundStyle(.blue.opacity(opacity))
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, padding)
                    Spacer()
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showSignup) {
                SignUpView()
            }
        }
    }
    
    private func login() {
        Task {
            do {
                let response = try await networkManager.login(email: email, password: password)
                authManager.setUser(email: email, response.accessToken)
            } catch {
                self.errorMessage = authManager.errorMessage ?? ""
                self.showError = true
            }
        }
    }
    
    let backgroundColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.95, green: 0.94, blue: 0.88)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
    struct AuthTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }



#Preview {
    LoginView()
        .environment(AuthManager())
        .environment(NetworkManager())
}
