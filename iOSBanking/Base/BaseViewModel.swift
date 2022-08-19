//
//  BaseViewModel.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject, RequestingVM {
    
    @Published final var errorAlert = false
    @Published final var errorTitle = ""
    @Published final var errorBody = ""
    @Published var isRequesting = false
    
    final func handleError(error: Error, showAlert: Bool = true) {
        if let error = error as? AppError {
            if showAlert { errorAlert.toggle() }
            
            switch error {
                
            case .noInternet:
                if showAlert {
                    errorTitle = "Network Error"
                    errorBody = "Please check the internet connection"
                }
                
            case .other(let message):
                if showAlert {
                    errorTitle = "Error"
                    errorBody = message
                }
            case .authenticationFailed:
                if showAlert {
                    errorTitle = "Login failed"
                    errorBody = "Please try again."
                }
            }
        } else {
            print(error)
        }
    }
}

protocol RequestingVM {
    var isRequesting: Bool { get set }
}
