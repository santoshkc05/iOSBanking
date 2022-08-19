//
//  ForgotPasswordViewModel.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import Resolver

class ForgotPasswordViewModel: BaseViewModel {
    @Published var email = ""
    @Published var isEmailSent = false
    
    @Injected var forgotPasswordRepository: ForgotPasswordRepository
    
    @MainActor
    func sendResetLink() async {
        isRequesting = true
        let result = await forgotPasswordRepository.sendPasswordResetLink(to: email)
        isRequesting = false
        switch result {
        case .success():
            isEmailSent = true
            print("email sent")
        case .failure(let error):
            handleError(error: error)
        }
    }
}

