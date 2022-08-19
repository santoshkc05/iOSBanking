//
//  NetworkClient.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation
import Alamofire

protocol NetworkProvider {
    func request<T: Decodable>(_ info: RequestInfoConvertible) async throws -> T
}

class NetworkClient: NetworkProvider {
    
    private let session: Session
    
    init(session: Session) {
      self.session = session
    }
    
    func request<T>(_ info: RequestInfoConvertible) async throws -> T where T : Decodable {
        let requestInfo = info.asRequestInfo()
        
        let request = session.request(
          requestInfo.url,
          method: requestInfo.method,
          parameters: requestInfo.parameters,
          encoding: requestInfo.encoding,
          headers: requestInfo.headers,
          interceptor: requestInfo.interceptor,
          requestModifier: requestInfo.requestModifier)
          .cURLDescription { str in
            print(str)
          }
          .responseDecodable(completionHandler: {  (response: DataResponse<T, AFError>) in
              print(response.debugDescription)
              switch response.result {
              case .success(let str):
                  print("Success: \(str)")
              case .failure(let err):
                  print("Error: \(err.localizedDescription)")
              }
          })
        
        return try await request.serializingDecodable(T.self).value
    }
}

