//
//  ForgotPasswordRepository.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import Foundation
import FirebaseAuth
import Resolver

// MARK: Repository

protocol ForgotPasswordRepository {
    func sendPasswordResetLink(to email: String) async -> Result<Void, AppError>
}

class ForgotPasswordRepositoryImpl: ForgotPasswordRepository {
    
    @Injected var auth: ResetPasswordSendable
    
    func sendPasswordResetLink(to email: String) async -> Result<Void, AppError> {
        do {
            try await auth.sendPasswordReset(withEmail: email)
            return .success(())
        } catch {
            print(error)
            return Result.failure(.other(error.localizedDescription))
        }
    }
}

// MARK: Protocol

protocol ResetPasswordSendable {
    func sendPasswordReset(withEmail email: String) async throws
}

extension Auth: ResetPasswordSendable {}
