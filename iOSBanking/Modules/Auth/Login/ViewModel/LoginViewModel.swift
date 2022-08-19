//
//  LoginViewModel.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import Combine
import Resolver

class LoginViewModel: BaseViewModel {
    @Published var email = ""
    @Published var password = ""
    
    @Published var isEmailValid = false
    @Published var isPasswordCriteriaValid = false
    
    @Published var isLoginViewValid = false
    
    @Injected private var sessionManager: SessionManager
    @Injected private var emailAuthenticator: FirebaseEmailAuthenticator
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: Lifecycle
    override init() {
        super.init()
        initializeValidation()
    }
    
    // MARK: Login
    @MainActor
    func login() async {
        isRequesting = true
        let result = await emailAuthenticator.signIn(withEmail: email, password: password)
        isRequesting = false
        switch result {
        case .success(_):
            sessionManager.setSignIn()
        case .failure(let error):
            self.handleError(error: error)
        }
    }
}

// MARK: Validations

extension LoginViewModel {
    
    private func initializeValidation() {
        $email.map { $0.isValidEmail() }
            .weakAssign(to: \.isEmailValid, on: self)
            .store(in: &self.cancellableSet)
        
        $password.map { $0.count >= 6 }
            .weakAssign(to: \.isPasswordCriteriaValid, on: self)
            .store(in: &self.cancellableSet)
        
        
        Publishers.CombineLatest(
            $isEmailValid,
            $isPasswordCriteriaValid)
        .map { $0 && $1 }
        .weakAssign(to: \.isLoginViewValid, on: self)
        .store(in: &self.cancellableSet)
    }
}
