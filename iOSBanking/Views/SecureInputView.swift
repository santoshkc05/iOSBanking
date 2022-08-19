//
//  SecureInputView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct SecureInputView: View {

  // MARK: Lifecycle

  init(text: Binding<String>, placeholder: LocalizedStringKey, prompt: LocalizedStringKey) {
    _text = text
    title = placeholder
    self.prompt = prompt
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if let sfSymbolName = sfSymbolName {
          Image(systemName: sfSymbolName)
                .foregroundColor(Color(.label))
            .font(.headline)
            .frame(width: 20)
        }
        if isSecured {
          SecureField(title, text: $text)
        } else {
          TextField(title, text: $text)
        }
        Button(action: {
          isSecured.toggle()
        }) {
          Image(systemName: self.isSecured ? "eye.slash" : "eye")
            .accentColor(Color.App.primaryColor)
        }
      }.autocapitalization(.none)
        .padding(8)
        .frame(height: 48)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5).opacity(0.6))
      Text(prompt)
        .fixedSize(horizontal: false, vertical: true)
        .font(.caption)
    }
  }

  // MARK: Private

  private var sfSymbolName: String? = "lock"
  @Binding private var text: String
  @State private var isSecured = true
  private var title: LocalizedStringKey
  private var prompt: LocalizedStringKey

}

// MARK: - SecureInputView_Previews

struct SecureInputView_Previews: PreviewProvider {
  @State private static var name = ""
  static var previews: some View {
    SecureInputView(text: .constant(""), placeholder: "Password", prompt: "Password could not be empty")
  }
}
