//
//  LoginView.swift
//  LocoTasks
//
//

import SwiftUI

struct LoginView: View {
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    @Environment(LocoTasksViewModel.self) var manager
    
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
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                        Text("LocoTasks")
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
    
    let backgroundColor: LinearGradient = LinearGradient(
           gradient: Gradient(colors: [
            Color(red: 0.95, green: 0.94, blue: 0.88),
            Color(red: 0.93, green: 0.91, blue: 0.85),
            Color(red: 0.90, green: 0.89, blue: 0.83)
           ]),
           startPoint: .topLeading,
           endPoint: .bottomTrailing
       )
    
    
    private func login() {
        Task {
            do {
                let response = try await networkManager.login(email: email, password: password)
                // Potentially change here (might change my authmanager
                authManager.setToken(response.accessToken)
            } catch {
                self.errorMessage = authManager.errorMessage ?? ""
                self.showError = true
            }
        }
    }
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
        .environment(NetworkManager())
        .environment(AuthManager())
        .environment(LocoTasksViewModel())
}
