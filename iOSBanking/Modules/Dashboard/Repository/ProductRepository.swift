//
//  ProductRepository.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import Foundation

protocol ProductRepository {
    func getProducts() async -> Result<[Product], AppError>
    func saveProducts(product: Product) async -> Result<Void, AppError>
}

// TODO: Remove static data and integrate with backend
class ProductRepositoryImpl: ProductRepository {
    
    private var products: [Product] = [
        Product(id: "netflix", name: "Netflix", accountId: "+9779800", price: 7.0, date: Date(), image: "netflix"),
        Product(id: "spotify", name: "Spotify", accountId: "+977980", price: 9.0, date: Date(), image: "spotify"),
        Product(id: "books", name: "Books", accountId: "+9779800", price: 10.0, date: Date(), image: "books")
    ]
    
    func getProducts() async -> Result<[Product], AppError> {
        return .success(products)
    }
    
    func saveProducts(product: Product) async -> Result<Void, AppError> {
        products.append(product)
        return .success(())
    }
}
