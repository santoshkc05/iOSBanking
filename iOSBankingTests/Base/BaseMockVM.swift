//
//  BaseMockVM.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 12/08/2022.
//

import Foundation
@testable import iOSBanking

class BaseMockVM {
    
    var requestingVM: RequestingVM!
    var isRequestingStateBeforeCallingDependency = false
    
    func checkRequesting() {
        isRequestingStateBeforeCallingDependency = requestingVM.isRequesting
    }
}
