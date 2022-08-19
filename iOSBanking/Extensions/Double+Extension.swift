//
//  Double+Extension.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import Foundation

extension Double {
    
    func formatPrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self))
    }
}
