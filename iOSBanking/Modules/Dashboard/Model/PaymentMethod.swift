//
//  PaymentMethod.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation

struct PaymentMethod: Decodable, Identifiable {
    let id: String
    let type: String
    let customer: String
    let card: Card
}

struct Card: Decodable {
    let brand: String
    let expMonth: Float
    let expYear: Float
    let last4: String
}
