//
//  ProductView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct ProductView: View {
    
    let product: Product
    let isSelected: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(product.image ?? "")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                    .padding(.leading)
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.headline)
                    Spacer()
                    Text(product.accountId)
                        .font(.body)
                        .opacity(0.65)
                }
                .padding()
                Spacer()
                VStack {
                    Text(product.price.formatPrice() ?? "")
                        .font(.headline)
                    Spacer()
                    Text(product.date.toString())
                        .font(.body)
                        .opacity(0.65)
                }
                .padding()
            }
            .foregroundColor(isSelected ? Color(.systemBackground) : Color(.label))
            .background(isSelected ? Color(.label) : Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: Product(id: "1", name: "Netflix", accountId: "+97798123453", price: 100.1, date: Date(), image: "netflix"), isSelected: true)
            .environment(\.colorScheme, .dark)
    }
}
