//
//  MockNetworkClient.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation
@testable import iOSBanking

class MockNetworkClient: NetworkProvider {
    var isError = false
    var data: Any!
    var product: String?
    
    func request<T>(_ info: RequestInfoConvertible) async throws -> T where T : Decodable {
        
        self.product = info.asRequestInfo().parameters?["product"] as? String
        if isError {
            throw "Error"
        } else {
            return data as! T
        }
    }
}
