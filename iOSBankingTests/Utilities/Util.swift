//
//  Util.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation

func customInit<T>() -> T where T: NSObject {
   let instance = T.perform(NSSelectorFromString("new")).takeRetainedValue() as! T
   return instance
}
