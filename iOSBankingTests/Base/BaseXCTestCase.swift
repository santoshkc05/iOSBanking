//
//  BaseXCTestCase.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import XCTest
import Resolver

class BaseXCTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.setUpMockResolver()
    }

}
