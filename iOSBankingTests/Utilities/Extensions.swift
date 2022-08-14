//
//  Extensions.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation

extension String: Error {}

extension Result {
    var isSuccess: Bool { if case .success = self { return true } else { return false } }

    var isError: Bool {  return !isSuccess  }
}
