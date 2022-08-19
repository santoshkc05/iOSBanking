//
//  StripeRemoteRepository.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import Foundation
import Resolver

protocol StripeRemoteRepository {
    func createPaymentIntent(product: String) async -> Result<CreateIntentResponse, AppError>
    func getSavedCards() async -> Result<[PaymentMethod], AppError>
}

class StripeRemoteRepositoryImpl: StripeRemoteRepository {
    
    @Injected private var networkClient: NetworkProvider
    
    func createPaymentIntent(product: String) async -> Result<CreateIntentResponse, AppError> {
        do {
            let result: CreateIntentResponse = try await networkClient.request(AppEndPoints.createPaymentIntent(product: product))
            return .success(result)
        } catch {
            return .failure(.other("An error occured"))
        }
    }
    
    func getSavedCards() async -> Result<[PaymentMethod], AppError> {
        do {
            let result: [PaymentMethod] = try await networkClient.request(AppEndPoints.getSavedCards)
            return .success(result)
        } catch {
            return .failure(.other("An error occured"))
        }
    }
}
