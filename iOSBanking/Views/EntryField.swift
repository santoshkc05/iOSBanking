//
//  EntryField.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct EntryField: View {

  // MARK: Lifecycle

  init(
    textFieldStatus: Binding<EntryFieldStatus> = .constant(EntryFieldStatus.none),
    sfSymbolName: String? = nil,
    placeholder: LocalizedStringKey,
    prompt: LocalizedStringKey,
    keyboardType: UIKeyboardType = .default,
    field: Binding<String>) {
    _textFieldStatus = textFieldStatus
    self.sfSymbolName = sfSymbolName
    self.placeholder = placeholder
    self.prompt = prompt
    self.keyboardType = keyboardType
    _field = field
  }

  // MARK: Internal

  @Binding var textFieldStatus: EntryFieldStatus
  var sfSymbolName: String? = nil
  var placeholder: LocalizedStringKey
  var prompt: LocalizedStringKey
  var keyboardType: UIKeyboardType = .default
  @Binding var field: String

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        if let sfSymbolName = sfSymbolName {
          Image(systemName: sfSymbolName)
                .foregroundColor(Color(.label))
            .font(.headline)
            .frame(width: 20)
        }
        TextField(placeholder, text: $field)
      }.autocapitalization(.none)
        .padding(8)
        .frame(height: 48)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5).opacity(0.6))
      Text(prompt)
        .fixedSize(horizontal: false, vertical: true)
        .font(.caption)
    }
  }
}

// MARK: - EntryField_Previews

struct EntryField_Previews: PreviewProvider {
  static var previews: some View {
    EntryField(
      textFieldStatus: .constant(.error),
      sfSymbolName: "envelope",
      placeholder: "Email Address",
      prompt: "Enter a valid email address",
      field: .constant(""))
  }
}

// MARK: - EntryFieldStatus

enum EntryFieldStatus {
  case processing, error, success, none
}
