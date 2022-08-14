//
//  MockForgetPasswordRepository.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 13/08/2022.
//

import Foundation
@testable import iOSBanking

class MockForgotPasswordRepsository: BaseMockVM, ForgotPasswordRepository {
    
    var isError = false
    var email = ""
    
    func sendPasswordResetLink(to email: String) async -> Result<Void, AppError> {
        checkRequesting()
        self.email = email
        if isError {
            return .failure(.other("localized message"))
        }
        
        return .success(())
    }
}
