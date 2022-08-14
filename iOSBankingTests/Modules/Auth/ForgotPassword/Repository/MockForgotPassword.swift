//
//  MockForgotPassword.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation
import FirebaseAuth
import Firebase
@testable import iOSBanking

class MockForgotPassword: ResetPasswordSendable {
    
    var isError = false
    var email = ""
    
    func sendPasswordReset(withEmail email: String) async throws {
        self.email = email
        if isError {
            throw "Error"
        }
    }
}

