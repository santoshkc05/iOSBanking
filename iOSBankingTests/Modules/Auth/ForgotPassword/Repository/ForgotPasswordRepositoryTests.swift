//
//  ForgotPasswordRepositoryTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class ForgotPasswordRepositoryTests: BaseXCTestCase {
    
    var sut: ForgotPasswordRepositoryImpl!
    var mockAuth: MockForgotPassword!

    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { ForgotPasswordRepositoryImpl() }
        Resolver.mock.register { MockForgotPassword() }.implements(ResetPasswordSendable.self)
        
        sut = Resolver.resolve(ForgotPasswordRepositoryImpl.self)
        mockAuth = Resolver.resolve(ResetPasswordSendable.self) as? MockForgotPassword
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension ForgotPasswordRepositoryTests {
    
    func testSendPasswordResetLinkIsCalledWithRightParameter() async {
        let email = "test@gmail.com"
        let _ = await sut.sendPasswordResetLink(to: email)
        XCTAssertEqual(email, mockAuth.email)
    }
    
    func testSendPasswordResetLinkShouldReturnSuccessIfNoError() async {
        let email = "test@gmail.com"
        mockAuth.isError = false
        let result = await sut.sendPasswordResetLink(to: email)
        XCTAssertTrue(result.isSuccess)
    }
    
    func testSendPasswordResetLinkShouldReturnFailureIfError() async {
        let email = "test@gmail.com"
        mockAuth.isError = true
        let result = await sut.sendPasswordResetLink(to: email)
        XCTAssertTrue(result.isError)
    }
}
