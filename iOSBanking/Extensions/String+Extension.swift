//
//  String+Extension.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        guard !lowercased().hasPrefix("mailto:") else {
            return false
        }
        guard
            let emailDetector
                = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        else {
            return false
        }
        let matches
        = emailDetector.matches(
            in: self,
            options: NSRegularExpression.MatchingOptions.anchored,
            range: NSRange(location: 0, length: count))
        guard matches.count == 1 else {
            return false
        }
        return matches[0].url?.scheme == "mailto"
    }
}
