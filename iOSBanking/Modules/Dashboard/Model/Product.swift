//
//  Product.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: String
    let name: String
    let accountId: String
    let price: Double
    let date: Date
    let image: String?
}
