//
//  DHCWebView.swift
//  Flifin
//
//  Created by 최혜린 on 1/11/26.
//

import SwiftUI

import ComposableArchitecture

struct DHCWebView: View {
  @Bindable var store: StoreOf<DHCWebReducer>
  @Dependency(\.webViewService) var webViewService
  
  var body: some View {
    WebViewRepresentable(configuration: webViewService.getConfiguration())
      .ignoresSafeArea()
      .toolbar(.hidden, for: .tabBar)
      .toolbar(.hidden, for: .navigationBar)
      .onAppear {
        store.send(.onAppear)
      }
      .onDisappear {
        store.send(.onDisappear)
      }
      .toast(
        isPresented: $store.presentToast.sending(\.toastPresentedChanged),
        type: .textWithCheck(store.toastMessage)
      )
  }
}
