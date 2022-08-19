//
//  RequestInfo.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Alamofire

// MARK: - RequestInfoConvertible

protocol RequestInfoConvertible {
  func asRequestInfo() -> RequestInfo
}

// MARK: - RequestInfo

struct RequestInfo {

  // MARK: Lifecycle

  init(
    url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    interceptor: RequestInterceptor?,
    headers: HTTPHeaders? = nil,
    requestModifier: Session.RequestModifier? = nil) {
    self.url = url
    self.method = method
    self.parameters = parameters
    self.encoding = encoding
    self.headers = headers
    self.interceptor = interceptor
    self.requestModifier = requestModifier
  }

  // MARK: Internal

  var url: URLConvertible
  var method: HTTPMethod
  var parameters: Parameters?
  var encoding: ParameterEncoding
  var headers: HTTPHeaders?
  var requestModifier: Session.RequestModifier?
  var interceptor: RequestInterceptor?
}
