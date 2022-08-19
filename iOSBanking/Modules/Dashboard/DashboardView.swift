//
//  DashboardView.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI
import Resolver
import Stripe

struct DashboardView: View {
    
    @StateObject private var viewModel: DashboardViewModel = Resolver.resolve()
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    Section(header:
                                Text("Saved Cards")
                        .font(.title2)
                    ) {
                        if viewModel.paymentMethods.count < 1{
                            noCardView
                        } else {
                            ForEach(viewModel.paymentMethods) { item in
                                CardView(paymentMethod: item)
                            }
                        }
                    }
                    
                    Section(header: HStack {
                        Text("Saved payments").font(.title2)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add new")
                                .foregroundColor(Color(.label))
                            //                                .opacity(0.65)
                                .font(.title3)
                                .padding(.trailing)
                        }
                        
                    }) {
                        ForEach(viewModel.products) { item in
                            ProductView(product: item, isSelected: self.selectedProduct == item).onTapGesture {
                                self.selectedProduct = item
                                Task {
                                    await viewModel.preparePaymentSheet(product: item.id)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .padding()
                .padding(.top, 50)
                
                stripePaymentUI
            }
            .navigationTitle("IOS Banking")
            .toolbar {
                Button("Sign Out") {
                    viewModel.signOut()
                }.foregroundColor(.red)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemBackground))
            .ignoresSafeArea()
            .alert(isPresented: $viewModel.isPaymentProcessCompleted, content: {
                Alert(title: Text("Payment"), message: Text(viewModel.getPaymentMessage()))
            })
            .onAppear {
                Task {
                    await viewModel.fetchProducts()
                    await viewModel.fetchSavedPaymentMethods()
                }
            }
        }
    }
    
    @ViewBuilder
    var noCardView: some View {
        HStack {
            Spacer()
            Text("No cards found")
                .font(.title2)
                .opacity(0.65)
                .padding()
            Spacer()
        }
    }
    
    @ViewBuilder
    var stripePaymentUI: some View {
        VStack(alignment: .center) {
            if let paymentSheet = viewModel.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: viewModel.onPaymentCompletion
                ) {
                    HStack {
                      Spacer()
                        Text("Pay")
                            .foregroundColor(Color(.systemBackground))
                      Spacer()
                    }
                        .padding(5)
                        .frame(height: 48)
                        .background(Color(.label).cornerRadius(8))
                }
            } else {
                Button(viewModel.isRequesting ? "Loading" : "Select a payment", action: {})
                    .buttonStyle(PrimaryButtonStyle(isEnabled: false))
            }
        }
        .padding()
        .padding(.bottom, 20)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.colorScheme, .dark)
    }
}
