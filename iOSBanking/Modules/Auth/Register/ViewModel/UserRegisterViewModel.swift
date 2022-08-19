//
//  UserRegisterViewModel.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import Combine
import Resolver

class UserRegisterViewModel: BaseViewModel {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isEmailValid = false
    @Published var isPasswordCriteriaValid = false
    @Published var isPasswordConfirmValid = false
    
    //Check if whole view is valid
    @Published var isRegisterViewValid = false
    
    @Injected private var userRegisterRepository: FirebaseRegisterUserRepository
    @Injected private var sessionManager: SessionManager
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: Lifecycle
    override init() {
        super.init()
        initializeValidation()
    }
    
    // MARK: Register
    @MainActor
    func register() async {
        isRequesting = true
        let result = await userRegisterRepository.register(withEmail: email, password: password)
        isRequesting = false
        switch result {
        case .success(let user):
            print("user created with id: \(user.id)")
            sessionManager.setSignIn()
        case .failure(let error):
            self.handleError(error: error)
        }
    }
    
    deinit {
        print("deinit")
    }
}


// MARK: Validations

extension UserRegisterViewModel {
    
    private func initializeValidation() {
        $email.map { email in
          email.isValidEmail()
        }
        .weakAssign(to: \.isEmailValid, on: self)
        .store(in: &cancellableSet)

      $password.map { password in
        password.count >= 6
      }
      .weakAssign(to: \.isPasswordCriteriaValid, on: self)
      .store(in: &cancellableSet)

      Publishers.CombineLatest($password, $confirmPassword)
        .map { password, confirmPw in
          password == confirmPw
        }
        .weakAssign(to: \.isPasswordConfirmValid, on: self)
        .store(in: &cancellableSet)


      Publishers.CombineLatest3(
        $isEmailValid,
        $isPasswordCriteriaValid,
        $isPasswordConfirmValid)
        .map { $0 && $1 && $2 }
        .weakAssign(to: \.isRegisterViewValid, on: self)
        .store(in: &cancellableSet)
    }
}
