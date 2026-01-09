//
//  RewardDetailReducer.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import Foundation

import ComposableArchitecture

@Reducer
struct RewardDetailReducer {
  init() {}

  @ObservableState
  struct State: Equatable {
    var rewardFortuneDetail: RewardFortuneDetail
    
    var title: String { rewardFortuneDetail.title }
    var scoreInfo: RewardFortuneDetail.FortuneScore { rewardFortuneDetail.scoreInfo }
    var cardInfo: RewardFortuneDetail.FortuneCard { rewardFortuneDetail.cardInfo }
    var overallFortune: RewardFortuneDetail.OverallFortune { rewardFortuneDetail.overallFortune }
    var categoryFortuneItems: [RewardFortuneDetail.CategoryFortuneItem] { rewardFortuneDetail.categoryFortuneItems }
    var elementBalance: RewardFortuneDetail.ElementBalance { rewardFortuneDetail.elementBalance }
    var elementShift: RewardFortuneDetail.ElementShift { rewardFortuneDetail.elementShift }
    var tipInfos: [RewardFortuneDetail.Tip] { rewardFortuneDetail.tipInfos }

    init(rewardFortuneDetail: RewardFortuneDetail = .sample) {
      self.rewardFortuneDetail = rewardFortuneDetail
    }
  }

  enum Action {
    // View Action
    case backButtonTapped
    case onAppear
    
    // Internal Action
    
    // Route Action
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
        
      case .onAppear:
        return .none
      }
    }
  }
}
