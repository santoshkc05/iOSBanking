//
//  NetworkManager.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Alamofire

class NetworkManager {

  // MARK: Lifecycle

  private init() {
    let urlConfiguration = URLSessionConfiguration.default
    urlConfiguration.timeoutIntervalForRequest = requestTimeOutInterval
    urlConfiguration.timeoutIntervalForResource = responseTimeOutInterval
    session = Session(configuration: urlConfiguration)
  }

  // MARK: Internal

  static let shared = NetworkManager()

  let session: Alamofire.Session

  // MARK: Private

  private let requestTimeOutInterval: Double = 45 //seconds
  private let responseTimeOutInterval: Double = 45
}
