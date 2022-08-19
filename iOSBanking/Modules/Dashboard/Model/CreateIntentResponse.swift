//
//  CreateIntentResponse.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation

struct CreateIntentResponse: Decodable {
    let secret: String
    let ephemeralKey: String
    let customer: String
}
