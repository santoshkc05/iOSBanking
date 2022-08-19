//
//  ErrorPresenter.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct ErrorPresenter: ViewModifier {
  @StateObject var vm: BaseViewModel

  func body(content: Content) -> some View {
    if #available(iOS 15.0, *) {
      content
        .alert(vm.errorTitle, isPresented: $vm.errorAlert, actions: {}, message: { Text(vm.errorBody) })
    } else {
      content.alert(isPresented: $vm.errorAlert, content: {
        Alert(title: Text(vm.errorTitle), message: Text(vm.errorBody))
      })
    }
  }
}

extension View {
  func handleError(with viewModel: BaseViewModel) -> some View {
    modifier(ErrorPresenter(vm: viewModel))
  }
}
