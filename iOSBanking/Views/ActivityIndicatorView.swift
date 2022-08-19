//
//  ActivityIndicatorView.swift
//  iOSBanking
//
//  Created by Santosh KC on 18/08/2022.
//

import SwiftUI

struct ActivityIndicatorView: ViewModifier {
  @StateObject var vm: BaseViewModel
  var text = "Please wait"

  func body(content: Content) -> some View {
    GeometryReader { _ in
      ZStack {
        content
              .disabled(vm.isRequesting)
          .blur(radius: vm.isRequesting ? 3 : 0)
        VStack {
          Text(text)
          ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
        .frame(width: 100, height: 100)
        .background(Color.secondary.colorInvert())
        .foregroundColor(Color.primary)
        .cornerRadius(20)
        .opacity(vm.isRequesting ? 1 : 0)
      }
    }
  }
}

extension View {
  func activityIndicator(with viewModel: BaseViewModel) -> some View {
    modifier(ActivityIndicatorView(vm: viewModel))
  }
}


struct ActivityIndicator: UIViewRepresentable {
  typealias UIViewType = UIActivityIndicatorView

  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style

  func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    UIActivityIndicatorView(style: style)
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }

  static func dismantleUIView(_: UIActivityIndicatorView, coordinator _: ()) {}
}
