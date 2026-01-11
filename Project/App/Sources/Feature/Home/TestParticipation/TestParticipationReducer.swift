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
      case dismiss
      case participate
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .closeButtonTapped:
        return .send(.delegate(.dismiss))
        
      case .participateButtonTapped:
        return .send(.delegate(.participate))
        
      case .delegate:
        return .none
      }
    }
  }
}

