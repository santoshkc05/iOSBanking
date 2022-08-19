//
//  RegisterView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI
import Resolver

struct RegisterView: View {
    
    @StateObject private var viewModel: UserRegisterViewModel = Resolver.resolve()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Register")
                    .fontWeight(.bold)
                    .font(.title)
                
                EntryField(
                    sfSymbolName: "envelope",
                    placeholder: "Email",
                    prompt: viewModel.isEmailValid ? "" : "Enter a valid email",
                    field: $viewModel.email)
                SecureInputView(
                    text: $viewModel.password,
                    placeholder: "Password",
                    prompt: viewModel.isPasswordCriteriaValid ? "" : "Enter a valid password")
                SecureInputView(
                    text: $viewModel.confirmPassword,
                    placeholder: "Confirm Password",
                    prompt: viewModel.isPasswordConfirmValid ? "" : "Password should match with confirm password")
                
                HStack {
                    Button("Create account", action: {
                        Task {
                            await viewModel.register()
                        }
                    })
                    .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isRegisterViewValid))
                }
            }
            .padding()
        }
        .handleError(with: viewModel)
        .activityIndicator(with: viewModel)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environment(\.colorScheme, .dark)
    }
}
