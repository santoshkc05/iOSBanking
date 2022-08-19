//
//  App+Injection.swift
//  iOSBanking
//
//  Created by Santosh KC on 10/08/2022.
//

import Foundation
import Resolver
import FirebaseAuth
import Firebase

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        defaultScope = .graph
        
        //Firebase Auth
        register { Auth.auth() }.implements(UserCreatable.self)
        register { Auth.auth() }.implements(ResetPasswordSendable.self)
        register { Auth.auth() }.implements(UserLoginable.self)
        register { Firestore.firestore()}.implements(FireStoreStorable.self)
        
        // Register Module
        register { FirebaseRegisterUserRepositoryImpl() }.implements(FirebaseRegisterUserRepository.self)
        register { UserRegisterViewModel() }
        
        //Login Module
        register { FirebaseEmailAuthenticatorImpl() }.implements(FirebaseEmailAuthenticator.self)
        register { LoginViewModel() }
        
        //Forgot Password Module
        register { ForgotPasswordRepositoryImpl() }.implements(ForgotPasswordRepository.self)
        register { ForgotPasswordViewModel() }
        
        //Dashboard module
        register { StripeRemoteRepositoryImpl() }.implements(StripeRemoteRepository.self)
        register { ProductRepositoryImpl() }.implements(ProductRepository.self)
        register { DashboardViewModel() }
        
        //Network Module
        register { NetworkClient(session: NetworkManager.shared.session) }.implements(NetworkProvider.self)
        
        //SessionManager
        register { SessionManagerImpl() }.implements(SessionManager.self)
    }
}
