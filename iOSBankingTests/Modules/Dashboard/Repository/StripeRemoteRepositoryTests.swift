//
//  StripeRemoteRepositoryTests.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 17/08/2022.
//

import XCTest
import Resolver
@testable import iOSBanking

class StripeRemoteRepositoryTests: BaseXCTestCase {
    
    var sut: StripeRemoteRepositoryImpl!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        
        Resolver.mock.register { StripeRemoteRepositoryImpl() }
        Resolver.mock.register { MockNetworkClient() }.implements(NetworkProvider.self)
        
        sut = Resolver.mock.resolve(StripeRemoteRepositoryImpl.self)
        mockNetworkClient = Resolver.mock.resolve(NetworkProvider.self) as? MockNetworkClient
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
    }
}

// MARK: Tests

extension StripeRemoteRepositoryTests {
    
    func testCreatePaymentShouldReturnFailureResultIfErrorOccured() async {
        mockNetworkClient.isError = true
        let result = await sut.createPaymentIntent(product: "netflix")
        XCTAssertTrue(result.isError)
    }
    
    func testCreatePaymentShouldReturnSuccessResultIfNoErrorOccured() async {
        mockNetworkClient.isError = false
        mockNetworkClient.data = CreateIntentResponse(secret: "test_secret", ephemeralKey: "test_ephemeralKey", customer: "test_customer")
        let result = await sut.createPaymentIntent(product: "netflix")
        XCTAssertTrue(result.isSuccess)
    }
    
    func testCreatePaymentShouldCallWithCorrectParameter() async {
        mockNetworkClient.isError = true
        _ = await sut.createPaymentIntent(product: "netflix")
        XCTAssertEqual(mockNetworkClient.product, "netflix")
    }
    
    func testgetSavedCardsShouldReturnFailureResultIfErrorOccured() async {
        mockNetworkClient.isError = true
        let result = await sut.getSavedCards()
        XCTAssertTrue(result.isError)
    }
    
    func testgetSavedCardsShouldReturnSuccessResultIfNoErrorOccured() async {
        mockNetworkClient.isError = false
        mockNetworkClient.data = [PaymentMethod]()
        let result = await sut.getSavedCards()
        XCTAssertTrue(result.isSuccess)
    }
}
