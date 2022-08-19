//
//  CardView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct CardView: View {
    
    let paymentMethod: PaymentMethod
    
    var body: some View {
        VStack {
            HStack {
                Text("Personal Card")
                    .font(.headline)
                Spacer()
                Text(paymentMethod.card.brand.uppercased())
                    .font(.title)
            }
            Spacer()
            HStack {
                Text("**** **** **** **** \(paymentMethod.card.last4)")
                    .font(.title3)
                    .opacity(0.7)
                Spacer()
                Text("Exp: \(Int(paymentMethod.card.expMonth))/\(String(Int(paymentMethod.card.expYear)))")
                    .font(.subheadline)
                    .opacity(0.7)
            }
            
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(.systemGray2), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
        )
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 200,
            maxHeight: 200,
            alignment: .topLeading
        )
        .cornerRadius(10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let paymentMethod = PaymentMethod(id: "1", type: "card", customer: "123", card: Card(brand: "visa", expMonth: 12, expYear: 2030, last4: "1234"))
        CardView(paymentMethod: paymentMethod).environment(\.colorScheme, .light)
    }
}
