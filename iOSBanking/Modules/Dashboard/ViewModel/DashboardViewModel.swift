//
//  DashboardViewModel.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import Stripe
import Resolver

/*
 TODO: Tests the viewmodel
 To know how to test it please check the viewmodel tests inside Auth module (UserRegisterViewModelTests, LoginViewModelTests, ForgotPasswordViewModelTests).
 */

class DashboardViewModel: BaseViewModel {
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var isPaymentProcessCompleted: Bool = false
    
    @Published var products: [Product] = []
    @Published var paymentMethods: [PaymentMethod] = []
    
    @Injected private var stripeRemoteRepository: StripeRemoteRepository
    @Injected private var productRepository: ProductRepository
    @Injected private var sessionManager: SessionManager
    
    @MainActor
    func preparePaymentSheet(product: String) async {
        isRequesting = true
        let response = await stripeRemoteRepository.createPaymentIntent(product: product)
        switch response {
        case .failure(let error):
            handleError(error: error)
        case .success(let response):
            initializeStripe(response: response)
        }
        isRequesting = false
    }
    
    @MainActor
    func fetchSavedPaymentMethods() async {
        let response = await stripeRemoteRepository.getSavedCards()
        switch response {
        case .failure(let error):
            handleError(error: error)
        case .success(let paymentMethods):
            self.paymentMethods = paymentMethods
        }
    }
    
    @MainActor
    func fetchProducts() async {
        let result = await productRepository.getProducts()
        switch result {
        case .failure(let error):
            handleError(error: error)
        case .success(let products):
            self.products = products
        }
    }
    
    func signOut() {
        sessionManager.signOut()
    }
    
    /*
     TODO: 1) Upload image and send image url to the backend
           2) Associate with real accountId
           3) Allow user to choose date
           4) Do not generate productId in client side.
    */
    @MainActor
    func saveProducts(
        name: String,
        price: Double
    ) async {
        let product = Product(id: UUID().uuidString, name: name, accountId: "+9779810001010", price: price, date: Date(), image: nil)
        let result = await productRepository.saveProducts(product: product)
        
        switch result {
        case .failure(let error):
            handleError(error: error)
        case .success(_):
            self.products.append(product)
            print("success")
        }
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        self.paymentSheet = nil
        self.isPaymentProcessCompleted = true
        Task {
            await fetchSavedPaymentMethods()
        }
      }
    
    func getPaymentMessage() -> String {
        if let result = paymentResult {
            switch result {
            case .completed:
                return "Payment complete"
            case .failed(let error):
                return "Payment failed: \(error.localizedDescription)"
            case .canceled:
                return "Payment canceled."
            }
        }
        return ""
    }
    
    private func initializeStripe(response: CreateIntentResponse) {
        STPAPIClient.shared.publishableKey = stripePublishableKey
        var configuration = PaymentSheet.Configuration()
        configuration.customer = .init(id: response.customer, ephemeralKeySecret: response.ephemeralKey)
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: response.secret, configuration: configuration)
    }
}
