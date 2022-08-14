//
//  ForgotPasswordViewModelTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class ForgotPasswordViewModelTests: BaseXCTestCase {
    
    var sut: ForgotPasswordViewModel!
    var mockRepository: MockForgotPasswordRepsository!

    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { ForgotPasswordViewModel() }.scope(.unique)
        Resolver.mock.register { MockForgotPasswordRepsository() }.implements(ForgotPasswordRepository.self)
        
        sut = Resolver.mock.resolve(ForgotPasswordViewModel.self)
        mockRepository = Resolver.mock.resolve(ForgotPasswordRepository.self) as? MockForgotPasswordRepsository
        mockRepository.requestingVM = sut
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension ForgotPasswordViewModelTests {
    
    func testSendResetLinkShouldBeCalledWithCorrectParameter() async {
        sut.email = "test@gmail.com"
        await sut.sendResetLink()
        XCTAssertEqual(sut.email, mockRepository.email)
    }
    
    func testSendResetLinkShouldNotHandleErrorIfNoError() async {
        sut.email = "test@gmail.com"
        mockRepository.isError = false
        await sut.sendResetLink()
        XCTAssertFalse(sut.errorAlert)
    }
    
    func testSendResetLinkShouldHandleErrorIfError() async {
        sut.email = "test@gmail.com"
        mockRepository.isError = true
        await sut.sendResetLink()
        XCTAssertTrue(sut.errorAlert)
    }
    
    func testSendResetLinkShouldSetEmailSentVariableIfSuccess() async {
        sut.email = "test@gmail.com"
        mockRepository.isError = false
        await sut.sendResetLink()
        XCTAssertTrue(sut.isEmailSent)
    }
    
    func testSendResetLinkShouldUnSetEmailSentVariableIfError() async {
        sut.email = "test@gmail.com"
        mockRepository.isError = true
        await sut.sendResetLink()
        XCTAssertFalse(sut.isEmailSent)
    }
    
    func testSendResetLinkShouldSetIsLoadingBeforeNetworkRequestAndUnsetAfterNetworkRequest() async {
        sut.email = "test@gmail.com"
        await sut.sendResetLink()
        XCTAssertTrue(mockRepository.isRequestingStateBeforeCallingDependency)
        XCTAssertFalse(sut.isRequesting)
    }
    
}
