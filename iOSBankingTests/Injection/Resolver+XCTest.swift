//
//  Resolver+XCTest.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation
import Resolver
import FirebaseAuth
@testable import iOSBanking

extension Resolver {
    
    //Mock Container
    static var mock = Resolver(child: .main)
    
    //Register Mock Services
    static func setUpMockResolver() {
        root = Resolver.mock
        defaultScope = .application
    }
}
