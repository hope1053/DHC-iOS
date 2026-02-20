//
//  RewardDetailReducer.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import Foundation

import ComposableArchitecture

enum RewardDetailType: Equatable {
  case sample
  case detail
}

@Reducer
struct RewardDetailReducer {
  init() {}
  
  @Dependency(\.dateFormatterCache) var dateFormatterCache

  @ObservableState
  struct State: Equatable {
    let type: RewardDetailType
    var rewardFortuneDetail: RewardFortuneDetail?
    
    var title: String { rewardFortuneDetail?.title ?? "" }
    var scoreInfo: RewardFortuneDetail.FortuneScore? { rewardFortuneDetail?.scoreInfo }
    var cardInfo: RewardFortuneDetail.FortuneCard? { rewardFortuneDetail?.cardInfo }
    var overallFortune: RewardFortuneDetail.OverallFortune? { rewardFortuneDetail?.overallFortune }
    var categoryFortuneItems: [RewardFortuneDetail.CategoryFortuneItem] { rewardFortuneDetail?.categoryFortuneItems ?? [] }
    var elementBalance: RewardFortuneDetail.ElementBalance? { rewardFortuneDetail?.elementBalance }
    var elementShift: RewardFortuneDetail.ElementShift? { rewardFortuneDetail?.elementShift }
    var tipInfos: [RewardFortuneDetail.Tip] { rewardFortuneDetail?.tipInfos ?? [] }

    init(type: RewardDetailType) {
      self.type = type
    }
  }

  enum Action {
    // View Action
    case backButtonTapped
    case onAppear
    
    // Internal Action
    case fetchRewardDetail
    case rewardDetailResponse(RewardFortuneDetail)
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
          // TODO: API Client 구현 시 실제 네트워크 호출로 대체
          // return .run { send in
          //   do {
          //     let rewardDetail = try await rewardAPIClient.fetchRewardDetail()
          //     await send(.rewardDetailResponse(rewardDetail))
          //   } catch {
          //     await send(.rewardDetailError(error))
          //   }
          // }
          
          // 임시: 샘플 데이터 사용
          state.rewardFortuneDetail = .sample(date: dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date()))
          return .none
          
        case .sample:
          state.rewardFortuneDetail = .sample(date: dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date()))
          return .none
        }
        
      case .rewardDetailResponse(let detail):
        state.rewardFortuneDetail = detail
        return .none
        
      case .rewardDetailError:
        // TODO: 에러 핸들링 구현
        return .none
      }
    }
  }
}
