//
//  FirebaseRegisterUserRepository.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import FirebaseAuth
import Resolver

// MARK: Repository

protocol FirebaseRegisterUserRepository {
    func register(
        withEmail email: String,
        password: String
    ) async -> Result<AppUser, AppError>
}

class FirebaseRegisterUserRepositoryImpl: FirebaseRegisterUserRepository {
    
    // Removed dependencies on outer infrastructures
    @Injected private var auth: UserCreatable
    
    func register(withEmail email: String, password: String) async -> Result<AppUser, AppError> {
        do {
            let user = try await auth.createUser(withEmail: email, password: password).user
            return Result.success(AppUser(id: user.uid, email: user.email!, photoURL: user.photoURL))
        } catch {
            print("Registration failed: \(error)")
            return Result.failure(AppError.other("Registration Failed"))
        }
    }
}


// MARK: Protocol

protocol UserCreatable {
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResult
}

extension Auth: UserCreatable {}
