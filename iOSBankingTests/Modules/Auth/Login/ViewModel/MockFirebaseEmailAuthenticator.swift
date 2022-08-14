//
//  MockFirebaseEmailAuthenticator.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import Foundation
@testable import iOSBanking

class MockFirebaseEmailAuthenticator: BaseMockVM, FirebaseEmailAuthenticator {
    
    var isError = false
    
    func signIn(withEmail email: String, password: String) async -> Result<AppUser, AppError> {
        checkRequesting()
        if isError {
            return .failure(.authenticationFailed)
        } else {
            return .success(AppUser(id: "testId", email: "test@gmail.com", photoURL: nil))
        }
    }
}
