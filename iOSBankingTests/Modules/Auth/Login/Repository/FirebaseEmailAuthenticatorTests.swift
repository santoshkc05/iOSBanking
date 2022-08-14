//
//  FirebaseEmailAuthenticatorTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class FirebaseEmailAuthenticatorTests: BaseXCTestCase {

    var sut: FirebaseEmailAuthenticatorImpl!
    var mockAuth: MockLoginAuth!
    
    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { FirebaseEmailAuthenticatorImpl() }.scope(.unique)
        Resolver.mock.register {
            MockLoginAuth()
        }.implements(UserLoginable.self)
        
        sut = Resolver.mock.resolve(FirebaseEmailAuthenticatorImpl.self)
        mockAuth = Resolver.mock.resolve(UserLoginable.self) as? MockLoginAuth
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension FirebaseEmailAuthenticatorTests {
    
    func testSingInIsCalledWithRightParameters() async {
        let email = "test@gmail.com"
        let password = "strong123"
        _ = await sut.signIn(withEmail: email, password: password)
        XCTAssertEqual(email, mockAuth.email)
        XCTAssertEqual(password, mockAuth.password)
    }
    
    func testSignInMustReturnSuccessIfNoError() async {
        let email = "test@gmail.com"
        let password = "strong123"
        mockAuth.isError = false
        let response = await sut.signIn(withEmail: email, password: password)
        XCTAssertTrue(response.isSuccess)
    }
    
    func testSignInMustReturnFailureIfError() async {
        let email = "test@gmail.com"
        let password = "strong123"
        mockAuth.isError = true
        let response = await sut.signIn(withEmail: email, password: password)
        XCTAssertTrue(response.isError)
    }
}
