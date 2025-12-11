//
//  RewardReducer.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import ComposableArchitecture

@Reducer
struct RewardReducer {
  init() {}

  @ObservableState
  struct State: Equatable {

    init() {
    }
  }

  enum Action {
    // View Action
    
    // Internal Action
    
    // Route Action
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}
