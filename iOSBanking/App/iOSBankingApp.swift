//
//  iOSBankingApp.swift
//  iOSBanking
//
//  Created by Santosh KC on 09/08/2022.
//

import SwiftUI

@main
struct iOSBankingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Color.App.primaryColor)
        }
    }
}
