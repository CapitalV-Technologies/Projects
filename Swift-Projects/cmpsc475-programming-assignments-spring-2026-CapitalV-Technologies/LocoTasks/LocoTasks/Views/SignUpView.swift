//
//  SignUpView.swift
//  LocoTasks
//
//
//

import SwiftUI

struct SignUpView: View {
    @Environment(NetworkManager.self) private var networkManager
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let minPasswordLength = 8
    var body: some View {
        let padding: CGFloat = 30
        let imageWidth: CGFloat = 100
        let imageHeight: CGFloat = 100
        let buttonHeight: CGFloat = 50
        let cornerRadius: CGFloat = 12
        let opacity = 0.5
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack(spacing: padding) {
                    Spacer()
                    // Logo/Title
                    VStack(spacing: padding / 3) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                        Text("Create Account")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    // Signup Form
                    VStack(spacing: padding / 1.5) {
                        // Email Field
                        VStack(alignment: .leading, spacing: padding / 3) {
                            Text("Email:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            
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
                                .foregroundStyle(.black)
                            
                            SecureField("Enter Password", text: $password)
                            // Need this or else SwiftUI does a weird security thing where I can't see the password being typed!
                                .textContentType(.oneTimeCode)
                                .textFieldStyle(AuthTextFieldStyle())
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: padding / 3) {
                            Text("Confirm Password:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            SecureField("Re-enter Password", text: $confirmPassword)
                                .textFieldStyle(AuthTextFieldStyle())
                        }
                        
                        // Error message for password mismatch
                        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                            Text("Passwords don't match")
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                        }
                        // Sign Up Button
                        Button {
                            self.signup()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Sign Up")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: buttonHeight)
                            .background(.gray)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                        .padding(.vertical, padding / 2)
                        .disabled(isLoading || !isValidForm)
                        .opacity((isLoading || !isValidForm) ? opacity : 1.0)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword && password.count < minPasswordLength {
                            HStack(spacing: padding / 5) {
                                Text("Password must be at least 8 characters long")
                                    .foregroundStyle(.blue.opacity(opacity))
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(padding)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage)
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
    
    private var isValidForm: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= minPasswordLength
    }
    
    // MARK: - Actions
    
    private func signup() {
        //TODO: signup action
        Task {
            do {
                let response = try await networkManager.signup(email: email, password: password)
                // Potentially change here
                authManager.setToken(response.accessToken)
                dismiss()
            } catch {
                self.errorMessage = authManager.errorMessage ?? ""
                self.showError = true
            }
        }
    }
}

#Preview {
    SignUpView()
        .environment(NetworkManager())
        .environment(AuthManager())
        .environment(LocoTasksViewModel())
}
