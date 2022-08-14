//
//  MockLoginAuth.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation
import FirebaseAuth
import Firebase
@testable import iOSBanking

class MockLoginAuth: UserLoginable {
    
    var isError = false
    var email = ""
    var password = ""
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
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
