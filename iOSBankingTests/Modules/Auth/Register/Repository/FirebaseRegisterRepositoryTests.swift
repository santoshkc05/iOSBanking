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
    var mockDB: MockFireStoreDB!
    
    override func setUp() {
        super.setUp()
        
        // Register dependencies
        Resolver.mock.register{ FirebaseRegisterUserRepositoryImpl() }
        Resolver.mock.register { MockRegisterAuth() }.implements(UserCreatable.self)
        Resolver.mock.register { MockFireStoreDB() }.implements(FireStoreStorable.self)
        
        sut = Resolver.mock.resolve(FirebaseRegisterUserRepositoryImpl.self)
        mockAuth = Resolver.mock.resolve(UserCreatable.self) as? MockRegisterAuth
        mockDB = Resolver.mock.resolve(FireStoreStorable.self) as? MockFireStoreDB
    }
    
    override func tearDown() {
        sut = nil
        mockDB = nil
        mockAuth = nil
        
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
    
    func testRegisterCorrectDataShouldBeStoredInFirestoreAfterSuccessFullRegister() async {
        
        let testEmail = "test2@gmail.com"
        let testPassword = "strong123"
        mockAuth.isError = false
        mockAuth.setUID(uid: "testUUID")
        
        _ = await sut.register(withEmail: testEmail, password: testPassword)
        
        XCTAssertEqual(mockDB.collectionName, "users")
        XCTAssertEqual(mockDB.documentPath, "testUUID")
        XCTAssertTrue(mockDB.merge)
        XCTAssertEqual(mockDB.storedData["email"] as! String, testEmail)
    }
}
