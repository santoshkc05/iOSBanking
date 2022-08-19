//
//  AppEndpoints.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation
import Alamofire

enum AppEndPoints: RequestInfoConvertible {
case createPaymentIntent(product: String)
case getSavedCards
}

extension AppEndPoints {
    
    static let baseUrl = "http://localhost:8080"
    
    var path: String {
        switch self {
        case .createPaymentIntent:
            return "create-payment-intent"
        case .getSavedCards:
            return "get-cards"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createPaymentIntent:
            return .post
        case .getSavedCards:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .createPaymentIntent(let product):
            return ["product":product]
        case .getSavedCards:
            return nil
        }
    }
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var urlString: String {
        AppEndPoints.baseUrl + "/" + path
    }
    
    var authIntercepter: RequestInterceptor? {
        AuthIntercepter()
    }
    
    func asRequestInfo() -> RequestInfo {
        RequestInfo(
            url: urlString,
            method: method,
            parameters: parameters,
            encoding: encoding,
            interceptor: authIntercepter,
            headers: headers)
    }
    
}
