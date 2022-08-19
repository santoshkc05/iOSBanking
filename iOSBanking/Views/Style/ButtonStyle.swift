//
//  ButtonStyle.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

  // MARK: Lifecycle

  init(isEnabled: Bool = true) {
    self.isEnabled = isEnabled
  }

  // MARK: Internal

  let isEnabled: Bool

  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
        configuration.label.foregroundColor(Color(.systemBackground))
      Spacer()
    }
    .padding(5)
    .frame(height: 48)
    .background(Color(.label).cornerRadius(8))
    .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1)
//    .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 8)
    .opacity(isEnabled ? 1 : 0.6)
    .disabled(!isEnabled)
    .allowsHitTesting(isEnabled)
  }
}
