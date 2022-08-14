//
//  UserRegisterViewModelTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 11/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class UserRegisterViewModelTests: BaseXCTestCase {

    var sut: UserRegisterViewModel!
    var mockSessionManager: MockSessionManager!
    var mockRegisterUserRepository: MockFirebaseRegisterUserRepository!
    
    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { UserRegisterViewModel() }.scope(.unique)
        Resolver.mock.register { MockFirebaseRegisterUserRepository() }.implements(FirebaseRegisterUserRepository.self)
        Resolver.mock.register { MockSessionManager() }.implements(SessionManager.self).scope(.graph)
        
        sut = Resolver.mock.resolve(UserRegisterViewModel.self)
        mockSessionManager = Resolver.mock.resolve(SessionManager.self) as? MockSessionManager
        mockRegisterUserRepository = Resolver.mock.resolve(FirebaseRegisterUserRepository.self) as? MockFirebaseRegisterUserRepository
        
        mockRegisterUserRepository.requestingVM = sut
    }

    override func tearDown() {
        sut = nil
        mockSessionManager = nil
        mockRegisterUserRepository = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension UserRegisterViewModelTests {
    
    //MARK: Validation
    
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
    
    func testConfirmPasswordShouldWorkWhenMatchesWithPassword() {
        sut.password = "123456"
        sut.confirmPassword = "123456"
        XCTAssertTrue(sut.isPasswordConfirmValid)
    }
    
    func testConfirmPasswordShouldWorkWhenDoesNotMatchesWithPassword() {
        sut.password = "123456"
        sut.confirmPassword = "1234567"
        XCTAssertFalse(sut.isPasswordConfirmValid)
    }
    
    func testFormValidaionShouldWorkIfAllFieldsAreValid() {
        sut.email = "test@gmail.com"
        sut.password = "abcdef"
        sut.confirmPassword = "abcdef"
        XCTAssertTrue(sut.isRegisterViewValid)
    }
    
    func testFormValidaionShouldWorkIfEmailIsInValid() {
        sut.email = "test_gmail.com"
        sut.password = "abcdef"
        sut.confirmPassword = "abcdef"
        XCTAssertFalse(sut.isRegisterViewValid)
    }
    
    func testFormValidaionShouldWorkIfPasswordIsInValid() {
        sut.email = "test@gmail.com"
        sut.password = "abcde"
        sut.confirmPassword = "abcde"
        XCTAssertFalse(sut.isRegisterViewValid)
    }
    
    func testFormValidaionShouldWorkIfConfirmPasswordIsInValid() {
        sut.email = "test@gmail.com"
        sut.password = "abcdef"
        sut.confirmPassword = "abcde"
        XCTAssertFalse(sut.isRegisterViewValid)
    }
    
    // MARK: Register tests
    
    func testRegisterShouldSetSignInIfResultIsSuccess() async {
        mockRegisterUserRepository.isError = false
        await sut.register()
        XCTAssertTrue(mockSessionManager.isSetSignInCalled)
    }
    
    func testRegisterShouldHandleErrorIfResultIsFailure() async {
        mockRegisterUserRepository.isError = true
        await sut.register()
        XCTAssertTrue(sut.errorAlert)
    }
    
    func testRegisterShouldNotShowErrorIfResultIsSuccess() async {
        mockRegisterUserRepository.isError = false
        await sut.register()
        XCTAssertFalse(sut.errorAlert)
    }
    
    func testRegisterShouldSetIsRequestingBeforeNetworkRequestAndUnsetAfterNetworkRequest() async {
        await sut.register()
        XCTAssertTrue(mockRegisterUserRepository.isRequestingStateBeforeCallingDependency)
        XCTAssertFalse(sut.isRequesting)
    }
}
