//
//  AuthIntercepter.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Alamofire
import FirebaseAuth

class AuthIntercepter: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void)  {
        
        Auth.auth().currentUser?.getIDToken(completion: { token, error in
            if let error = error {
                print(error)
            }
            var urlRequestConfig = urlRequest
            urlRequestConfig.setValue(
              String(format: "Bearer %@", token ?? ""),
              forHTTPHeaderField: "Authorization")
            completion(.success(urlRequestConfig))
        })
    }
}
