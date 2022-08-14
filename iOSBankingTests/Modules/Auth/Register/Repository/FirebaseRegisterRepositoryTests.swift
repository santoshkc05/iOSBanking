//
//  FirebaseRegisterRepositoryTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import XCTest
import Resolver
import FirebaseAuth
@testable import iOSBanking

class FirebaseRegisterRepositoryTests: BaseXCTestCase {

    var mockAuth: MockRegisterAuth!
    var sut: FirebaseRegisterUserRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        
        // Register dependencies
        Resolver.mock.register{ FirebaseRegisterUserRepositoryImpl() }
        Resolver.mock.register { MockRegisterAuth() }.implements(UserCreatable.self)
        
        sut = Resolver.mock.resolve(FirebaseRegisterUserRepositoryImpl.self)
        mockAuth = Resolver.mock.resolve(UserCreatable.self) as? MockRegisterAuth
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

// MARK: Tests

extension FirebaseRegisterRepositoryTests {
    
    func testRegisterMethodShouldBeInvokedWithCorrectParameter() async {
        let testEmail = "test@gmail.com"
        let testPassword = "strong123"
        let _ = await sut.register(withEmail: testEmail, password: testPassword)
        XCTAssertEqual(mockAuth.email, testEmail)
        XCTAssertEqual(mockAuth.password, testPassword)
    }
    
    func testRegistrationShouldReturnSuccessIfNoErrorOccured() async {
        let testEmail = "test@gmail.com"
        let testPassword = "strong123"
        mockAuth.isError = false
        let result = await sut.register(withEmail: testEmail, password: testPassword)
        XCTAssertTrue(result.isSuccess)
    }
    
    func testRegistrationShouldReturnFailureIfErrorOccured() async {
        let testEmail = "test@gmail.com"
        let testPassword = "strong123"
        mockAuth.isError = true
        let result = await sut.register(withEmail: testEmail, password: testPassword)
        XCTAssertTrue(result.isError)
    }
}
