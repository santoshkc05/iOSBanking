//
//  App+Injection.swift
//  iOSBanking
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation
import Resolver
import FirebaseAuth

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        defaultScope = .graph
        
        //Firebase Auth
//        register { Auth.auth() }
        
        // Register Module
        register { FirebaseRegisterUserRepositoryImpl() }.implements(FirebaseRegisterUserRepository.self)
        register { UserRegisterViewModel() }
        
        //Login Module
        register { FirebaseEmailAuthenticatorImpl() }.implements(FirebaseEmailAuthenticator.self)
        register { LoginViewModel() }
        
        //Forgot Password Module
        register { ForgotPasswordRepositoryImpl() }.implements(ForgotPasswordRepository.self)
        register { ForgotPasswordViewModel() }
    }
}
