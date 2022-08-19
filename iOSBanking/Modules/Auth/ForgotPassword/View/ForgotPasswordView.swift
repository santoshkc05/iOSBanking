//
//  ForgotPasswordView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI
import Resolver

struct ForgotPasswordView: View {
    
    @StateObject private var viewModel: ForgotPasswordViewModel = Resolver.resolve()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            Text("Forgot Password")
              .font(.title)
              .fontWeight(.bold)

            Text("Please enter your email address to reset your password!")
              .multilineTextAlignment(.leading)
              .fixedSize(horizontal: false, vertical: true)

            EntryField(
              placeholder: "Email",
              prompt: viewModel.email.isValidEmail() ? "" : "Enter valid email",
              field: $viewModel.email)

              Button("Send Link") {
                  Task {
                      await viewModel.sendResetLink()
                  }
              }.buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.email.isValidEmail()))
          }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(.container, edges: .vertical)
        .padding()
        .handleError(with: viewModel)
        .activityIndicator(with: viewModel)
        .alert(isPresented: $viewModel.isEmailSent, content: {
            Alert(title: Text("Password Reset"), message: Text("Password reset link is sent to the email"), dismissButton: .default(Text("OK"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        })
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environment(\.colorScheme, .light)
    }
}
