//
//  DHCWebReducer.swift
//  Flifin
//
//  Created by 최혜린 on 1/11/26.
//

import Foundation

import ComposableArchitecture

@Reducer
struct DHCWebReducer {
  @Dependency(\.webViewService) var webViewService
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable {
    let url: URL
    var toastMessage = ""
    var presentToast = false
    
    init(url: URL) {
      self.url = url
    }
  }
  
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case onAppear
    case onDisappear
    case handleMessage(WebViewMessage)
    case closeWebView
    case goToMain
    case showToast(String)
    case toastPresentedChanged(Bool)
    
    enum Delegate {
      case navigateToMain
      case close
    }
    case delegate(Delegate)
  }
  
  private enum CancelID {
    case messageHandler
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run { [url = state.url] send in
          // URL 로딩
          await webViewService.loadURL(url)
          
          // 메시지 핸들러 설정
          await webViewService.setupMessageHandler { message in
            Task {
              await send(.handleMessage(message))
            }
          }
        }
        .cancellable(id: CancelID.messageHandler)
      
      case .onDisappear:
        return .cancel(id: CancelID.messageHandler)
        
      case .handleMessage(let message):
        switch message {
        case .close:
          return .send(.closeWebView)
        case .goToMain:
          return .send(.goToMain)
        case .showToast(let message):
          return .send(.showToast(message))
        }
        
      case .closeWebView:
        return .run { send in
          await send(.delegate(.close))
        }
        
      case .goToMain:
        return .run { send in
          await send(.delegate(.navigateToMain))
        }
        
      case .showToast(let message):
        state.toastMessage = message
        state.presentToast = true
        return .none
        
      case .toastPresentedChanged(let isPresented):
        state.presentToast = isPresented
        return .none

      case .delegate:
        return .none
      }
    }
  }
}

