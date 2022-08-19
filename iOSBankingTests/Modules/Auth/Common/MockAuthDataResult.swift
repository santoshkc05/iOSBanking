//
//  MockAuthDataResult.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import FirebaseAuth

// MARK: Firebase AuthDataResult

class MockAuthDataResult: AuthDataResult {
    private var mockUser: MockUser!
    
    override var user: MockUser {
        if mockUser == nil {
            mockUser = customInit()
        }
        return mockUser
    }
}

// MARK: Firebase User

class MockUser: User {
    private var _uid = ""
    private var _email = ""
    
    override var email: String? {
        get { _email }
        set { _email = newValue! }
    }
    
    override var photoURL: URL? {
        return URL(string: "https://www.google.com/test.png")
    }
    
    override var uid: String {
        get { _uid }
        set { _uid = newValue }
    }
}
