//
//  LoginViewModelTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class LoginViewModelTests: BaseXCTestCase {

    var sut: LoginViewModel!
    var mockSessionManager: MockSessionManager!
    var mockEmailAuthenticator: MockFirebaseEmailAuthenticator!
    
    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { LoginViewModel() }.scope(.unique)
        Resolver.mock.register { MockFirebaseEmailAuthenticator() }.implements(FirebaseEmailAuthenticator.self)
        Resolver.mock.register { MockSessionManager() }.implements(SessionManager.self)
        
        sut = Resolver.mock.resolve(LoginViewModel.self)
        mockSessionManager = Resolver.mock.resolve(SessionManager.self) as? MockSessionManager
        mockEmailAuthenticator = Resolver.mock.resolve(FirebaseEmailAuthenticator.self) as? MockFirebaseEmailAuthenticator
        
        mockEmailAuthenticator.requestingVM = sut
    }

    override func tearDown() {
        sut = nil
        mockSessionManager = nil
        mockEmailAuthenticator = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension LoginViewModelTests {
    
    //MARK: Validation tests
    
    func testEmailValidationShouldWorkWhenInvalidEmailIsProvided() {
        sut.email = "invalid_email"
        XCTAssertFalse(sut.isEmailValid)
    }
    
    func testEmailValidationShouldWorkWhenValidEmailIsProvided() {
        sut.email = "test@gmail.com"
        XCTAssertTrue(sut.isEmailValid)
    }
    
    func testPasswordValidationShouldWorkWhenInvalidPasswordIsProvided() {
        sut.password = "12345"
        XCTAssertFalse(sut.isPasswordCriteriaValid)
    }
    
    func testPasswordValidationShouldWorkWhenValidPasswordIsProvided() {
        sut.password = "123456"
        XCTAssertTrue(sut.isPasswordCriteriaValid)
    }
    
    
    func testFormValidaionShouldWorkIfAllFieldsAreValid() {
        sut.email = "test@gmail.com"
        sut.password = "abcdef"
        XCTAssertTrue(sut.isLoginViewValid)
    }
    
    func testFormValidaionShouldWorkIfEmailIsInValid() {
        sut.email = "test_gmail.com"
        sut.password = "abcdef"
        XCTAssertFalse(sut.isLoginViewValid)
    }
    
    func testFormValidaionShouldWorkIfPasswordIsInValid() {
        sut.email = "test@gmail.com"
        sut.password = "abcde"
        XCTAssertFalse(sut.isLoginViewValid)
    }
    
    // MARK: Login tests
    
    func testLoginShouldSetSignInIfResultIsSuccess() async {
        mockEmailAuthenticator.isError = false
        await sut.login()
        XCTAssertTrue(mockSessionManager.isSetSignInCalled)
    }
    
    func testLoginShouldNotSetSignInIfResultIsFailure() async {
        mockEmailAuthenticator.isError = true
        await sut.login()
        XCTAssertFalse(mockSessionManager.isSetSignInCalled)
    }
    
    func testLoginShouldHandleErrorIfResultIsFailure() async {
        mockEmailAuthenticator.isError = true
        await sut.login()
        XCTAssertTrue(sut.errorAlert)
    }
    
    func testLoginShouldNotShowErrorIfResultIsSuccess() async {
        mockEmailAuthenticator.isError = false
        await sut.login()
        XCTAssertFalse(sut.errorAlert)
    }
    
    func testLoginShouldSetIsRequestingBeforeNetworkRequestAndUnsetAfterNetworkRequest() async {
        await sut.login()
        XCTAssertTrue(mockEmailAuthenticator.isRequestingStateBeforeCallingDependency)
        XCTAssertFalse(sut.isRequesting)
    }
}
