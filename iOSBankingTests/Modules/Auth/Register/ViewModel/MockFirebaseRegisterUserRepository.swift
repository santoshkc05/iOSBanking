//
//  MockFirebaseRegisterUserRepository.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import Foundation
@testable import iOSBanking

class MockFirebaseRegisterUserRepository: BaseMockVM, FirebaseRegisterUserRepository {
    var isError = true
    func register(withEmail email: String, password: String) async -> Result<AppUser, AppError> {
        checkRequesting()
        if isError {
            return .failure(.other("Registration Failed"))
        }
        
        return .success(AppUser(id: "testid", email: "test@gmail.com", photoURL: nil))
    }
}
