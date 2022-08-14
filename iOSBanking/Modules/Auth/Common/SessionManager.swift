//
//  SessionManager.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI
import Combine
import FirebaseAuth

protocol SessionManager {
    func signOut()
    func setSignIn()
}

class SessionManagerImpl: SessionManager {
    
    @AppStorage(wrappedValue: false, StorageKey.isLoggedIn.rawValue) private var isLoggedIn
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            withAnimation {
              isLoggedIn = false
            }
        } catch {
            print("logout failed \(error)")
        }
    }
    
    func setSignIn() {
        withAnimation {
          isLoggedIn = true
        }
    }
}
