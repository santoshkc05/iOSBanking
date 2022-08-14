//
//  FirebaseEmailAuthenticator.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import FirebaseAuth
import Resolver

// MARK: Repository

protocol FirebaseEmailAuthenticator {
    func signIn(
        withEmail email: String,
        password: String
    ) async -> Result<AppUser, AppError>
}

class FirebaseEmailAuthenticatorImpl: FirebaseEmailAuthenticator {
    
    @Injected var auth: UserLoginable
    
    func signIn(withEmail email: String, password: String) async -> Result<AppUser, AppError> {
        do {
            let user = try await auth.signIn(withEmail: email, password: password).user
            
            return Result.success(AppUser(id: user.uid, email: user.email!, photoURL: user.photoURL))
        } catch {
            print("Sign In failed: \(error)")
            return Result.failure(AppError.authenticationFailed)
        }
    }
}

// MARK: Protocol

protocol UserLoginable {
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult
}

extension Auth: UserLoginable {}
