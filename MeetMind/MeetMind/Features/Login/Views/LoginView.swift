//
//  LoginView.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import SwiftUI

public struct LoginView: View {
    @State private var viewModel: LoginViewModel
    
    public init(authService: AuthServiceProtocol, appState: AppState, router: AppRouter) {
        _viewModel = State(initialValue: LoginViewModel(authService: authService, appState: appState, router: router))
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header Branding
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [AppColors.primary, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "book.pages.fill")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    Text("Learning Dashboard")
                        .font(AppTypography.titleLarge)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Sign in to access your enrolled courses and track your progress.")
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // Form Card
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email Address")
                            .font(AppTypography.subheadlineBold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(AppColors.textSecondary)
                            TextField("", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .overlay(alignment: .leading) {
                                    if viewModel.email.isEmpty {
                                        Text(verbatim: "name@example.com")
                                            .foregroundStyle(.gray)
                                            .allowsHitTesting(false)
                                    }
                                }
                        }
                        .font(AppTypography.bodyBold)
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.emailError != nil ? Color.red : Color.black.opacity(0.1), lineWidth: 1)
                        )
                        
                        if let emailError = viewModel.emailError {
                            Text(emailError)
                                .font(AppTypography.caption)
                                .foregroundColor(.red)
                                .transition(.opacity)
                        }
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(AppTypography.subheadlineBold)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(AppColors.textSecondary)
                            SecureField("", text: $viewModel.password)
                                .overlay(alignment: .leading) {
                                    if viewModel.password.isEmpty {
                                        Text("Enter your password")
                                            .foregroundStyle(.gray)
                                            .allowsHitTesting(false)
                                    }
                                }
                        }
                        .font(AppTypography.bodyBold)
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.passwordError != nil ? Color.red : Color.black.opacity(0.1), lineWidth: 1)
                        )
                        
                        if let passwordError = viewModel.passwordError {
                            Text(passwordError)
                                .font(AppTypography.caption)
                                .foregroundColor(.red)
                                .transition(.opacity)
                        }
                    }
                    
                    // General Error Banner
                    if let generalError = viewModel.generalError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(generalError)
                                .font(AppTypography.captionBold)
                        }
                        .foregroundColor(.red)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Login Button
                    PrimaryButton(
                        title: "Sign In",
                        isLoading: viewModel.isLoading,
                        action: {
                            Task {
                                await viewModel.login()
                            }
                        }
                    )
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                    .opacity(viewModel.isValid ? 1.0 : 0.6)
                    
                    // Demo Credentials Helper Note
                    VStack(spacing: 4) {
                        Text("Demo Credentials:")
                            .font(AppTypography.captionBold)
                            .foregroundColor(AppColors.textSecondary)
                        Text(verbatim: "Email: john@example.com | Password: password123")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary.opacity(0.8))
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                .padding(.horizontal, 16)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    LoginView(authService: MockAuthService(), appState: AppState(), router: AppRouter())
}
