//
//  MockAuthDataResult.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import FirebaseAuth

// MARK: Firebase AuthDataResult

class MockAuthDataResult: AuthDataResult {
    
    override var user: MockUser { return customInit() }
}

// MARK: Firebase User

class MockUser: User {
    
    override var email: String? {
        return "test@gmail.com"
    }
    
    override var photoURL: URL? {
        return URL(string: "https://www.google.com/test.png")
    }
}
