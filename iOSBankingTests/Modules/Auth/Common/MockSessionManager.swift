//
//  MockSessionManager.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import Foundation
@testable import iOSBanking

class MockSessionManager: SessionManager {
    var isSignOutCalled = false
    var isSetSignInCalled = false
    
    func signOut() {
        isSignOutCalled = true
    }
    
    func setSignIn() {
        isSetSignInCalled = true
    }
}
