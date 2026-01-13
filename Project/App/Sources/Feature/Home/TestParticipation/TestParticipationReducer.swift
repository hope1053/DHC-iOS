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
  @ObservableState
  struct State: Equatable {
    let test: HomeInfo.Test
  }
  
  enum Action {
    case closeButtonTapped
    case participateButtonTapped
    case delegate(Delegate)
    
    enum Delegate {
      case participate(url: URL?)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        // TODO: 서버 호출
        return .none
        
      case .participateButtonTapped:
        // TODO: 서버 호출
        return .send(.delegate(.participate(url: state.test.testURL)))
        
      case .delegate:
        return .none
      }
    }
  }
}

