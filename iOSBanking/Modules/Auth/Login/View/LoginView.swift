//
//  LoginView.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI
import Resolver

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel = Resolver.resolve()
    @State var showView = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    Image("lock")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(.label))
                        .padding(.top, 50)
                    
                    
                    signInMessage
                    
                    EntryField(
                        sfSymbolName: "envelope",
                        placeholder: "Email",
                        prompt: viewModel.isEmailValid ? "" : "Enter a valid email",
                        field: $viewModel.email)
                    SecureInputView(
                        text: $viewModel.password,
                        placeholder: "Password",
                        prompt: viewModel.isPasswordCriteriaValid ? "" : "Enter a valid password")
                    
                    HStack {
                        Spacer()
                        NavigationLink("Forgot Password?", destination: ForgotPasswordView())
                            .foregroundColor(Color(.label))
                    }
                    
                    HStack {
                        Button("Sign In", action: {
                            Task {
                                await viewModel.login()
                            }
                        })
                        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isLoginViewValid))
                    }
                    

                    NavigationLink(destination: RegisterView(), label: {
                        HStack {
                            Spacer()
                            Text("Don't have an account yet?").foregroundColor(Color(.label))
                            Text("Register")
                                .underline()
                                
                        }
                        
                    })
                }
                .padding()
            }
        }
        .activityIndicator(with: viewModel)
        .handleError(with: viewModel)
        .background(Color(.systemBackground))
        .ignoresSafeArea(.container, edges: .vertical)
    }
    
    @ViewBuilder
    var signInMessage: some View {
        VStack {
            Text("Sign In")
                .fontWeight(.bold)
                .font(.title)
            
            Text("Use your username and password to sign in to your account.")
                .multilineTextAlignment(.center)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environment(\.colorScheme, .dark)
    }
}
