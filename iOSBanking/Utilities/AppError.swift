//
//  AppError.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation

enum AppError: Error {
  case authenticationFailed
  case noInternet
  case other(String)
}
