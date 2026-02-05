//
//  TestParticipationReducer.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct TestParticipationReducer {
  @Dependency(\.testBannerStorage) var testBannerStorage
  
  @ObservableState
  struct State: Equatable {
    let test: HomeInfo.Test
  }
  
  enum Action {
    case closeButtonTapped
    case participateButtonTapped
    case delegate(Delegate)
    
    enum Delegate {
      case dismissBanner
      case participate(url: URL?)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        testBannerStorage.addDismissedVersion(state.test.version)
        return .send(.delegate(.dismissBanner))
        
      case .participateButtonTapped:
        testBannerStorage.addDismissedVersion(state.test.version)
        return .send(.delegate(.participate(url: state.test.testURL)))
        
      case .delegate:
        return .none
      }
    }
  }
}

