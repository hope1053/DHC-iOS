//
//  ShareTokenCookieReducer.swift
//  Flifin
//
//  Created by hyerin on 2/20/26.
//

import Foundation

import ComposableArchitecture

@Reducer
struct ShareTokenCookieReducer {
  @Dependency(\.shareClient) var shareClient
  @Dependency(\.userManager) var userManager
  @Dependency(\.webViewService) var webViewService
  
  @ObservableState
  struct State: Equatable {}
  
  enum Action {
    case prepare(URL)
    case delegate(Delegate)
    
    enum Delegate {
      case prepared(url: URL)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .prepare(let url):
        return .run { [shareClient, userManager, webViewService] send in
          if let userId = userManager.getUserID() {
            do {
              let shareCode = try await shareClient.createShareCode(userId)
              
              if let domain = url.host {
                await webViewService.setCookie("shareToken", shareCode, domain)
              } else {
                debugPrint("⚠️ [Share] URL domain을 추출할 수 없음: \(url)")
              }
            } catch {
              debugPrint("❌ [Share] shareCode 생성 실패: \(error)")
            }
          }
          
          await send(.delegate(.prepared(url: url)))
        }
        
      case .delegate:
        return .none
      }
    }
  }
}
