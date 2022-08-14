//
//  MockRegisterAuth.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import FirebaseAuth
import Firebase
@testable import iOSBanking

class MockRegisterAuth: UserCreatable {
    var isError = false
    var email = ""
    var password = ""
    
    
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResult {
        self.email = email
        self.password = password
        if isError {
            throw "Error"
        } else {
            let authDataResult: MockAuthDataResult = customInit()
            return authDataResult
        }
    }
}

