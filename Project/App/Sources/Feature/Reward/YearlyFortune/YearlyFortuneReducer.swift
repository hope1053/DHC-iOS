//
//  YearlyFortuneReducer.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import Foundation

import ComposableArchitecture

enum YearlyFortuneType: Equatable {
  case sample
  case detail
}

@Reducer
struct YearlyFortuneReducer {
  init() {}
  
  @Dependency(\.dateFormatterCache) var dateFormatterCache
  @Dependency(\.rewardClient) var rewardClient

  @ObservableState
  struct State: Equatable {
    let type: YearlyFortuneType
    var rewardFortuneDetail: YearlyFortune?
    
    var title: String { rewardFortuneDetail?.title ?? "" }
    var scoreInfo: YearlyFortune.FortuneScore? { rewardFortuneDetail?.scoreInfo }
    var cardInfo: FortuneCard? { rewardFortuneDetail?.cardInfo }
    var overallFortune: YearlyFortune.OverallFortune? { rewardFortuneDetail?.overallFortune }
    var categoryFortuneItems: [YearlyFortune.CategoryFortuneItem] { rewardFortuneDetail?.categoryFortuneItems ?? [] }
    var elementBalance: YearlyFortune.ElementBalance? { rewardFortuneDetail?.elementBalance }
    var elementShift: YearlyFortune.ElementShift? { rewardFortuneDetail?.elementShift }
    var tipInfos: [Tip] { rewardFortuneDetail?.tipInfos ?? [] }

    init(type: YearlyFortuneType) {
      self.type = type
    }
  }

  enum Action {
    // View Action
    case backButtonTapped
    case onAppear
    
    // Internal Action
    case fetchRewardDetail
    case rewardDetailResponse(YearlyFortune)
    case rewardDetailError(Error)
    
    // Route Action
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
        
      case .onAppear:
        return .send(.fetchRewardDetail)
        
      case .fetchRewardDetail:
        switch state.type {
        case .detail:
          return .run { [rewardClient] send in
            do {
              let rewardDetail = try await rewardClient.fetchYearlyFortune()
              await send(.rewardDetailResponse(rewardDetail))
            } catch {
              await send(.rewardDetailError(error))
            }
          }
          
        case .sample:
          state.rewardFortuneDetail = .sample(date: dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date()))
          return .none
        }
        
      case .rewardDetailResponse(let detail):
        state.rewardFortuneDetail = detail
        return .none
        
      case .rewardDetailError(let error):
        print("Failed to fetch yearly fortune detail: \(error)")
        state.rewardFortuneDetail = .sample(
          date: dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date())
        )
        return .none
      }
    }
  }
}
