//
//  ContentView.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage(wrappedValue: false, StorageKey.isLoggedIn.rawValue) private var isLoggedIn
    
    var body: some View {
        initialView()
    }
    
    @ViewBuilder
    private func initialView() -> some View {
      if isLoggedIn {
          DashboardView()
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
      } else {
        LoginView()
              .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
