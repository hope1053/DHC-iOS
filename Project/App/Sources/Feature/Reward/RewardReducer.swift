//
//  RewardReducer.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

import ComposableArchitecture

enum ReceivedRewardAction {
  case showToast(String)
  case moveToDetailView(Int)
}

@Reducer
struct RewardReducer {
  init() {}

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var rewardInfo: RewardInfo?
    var toastType: ToastType = .textWithCheck("")
    var isToastPresented: Bool = false
    
    var userProgressInfo: RewardInfo.UserProgressInfo? {
      rewardInfo?.userProgressInfo
    }

    init() {
    }
  }

  enum Action {
    // View Action
    case onAppear
    case onOpenRewardButtonTapped
    case onWhatIsRewardButtonTapped
    case infoButtonTapped
    case onRewardItemTapped(action: ReceivedRewardAction)
    case toastPresentedChanged(Bool)
    
    // Internal Action
    case fetchRewardProgress
    case fetchRewardProgressResponse(Result<RewardInfo, Error>)
    case showToast(ToastType)
    
    // Route Action
    case path(StackActionOf<Path>)
    case moveToRewardDetail(type: RewardDetailType)
  }
  
  @Reducer
  enum Path {
    case rewardDetail(RewardDetailReducer)
  }
  
  @Dependency(\.rewardClient) var rewardClient

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchRewardProgress)
        
      case .fetchRewardProgress:
        return .run { send in
          await send(
            .fetchRewardProgressResponse(
              Result {
                try await rewardClient.fetchRewardProcess()
              }
            )
          )
        }
        
      case .fetchRewardProgressResponse(.success(let rewardInfo)):
        state.rewardInfo = rewardInfo
        return .none
        
      case .fetchRewardProgressResponse(.failure(let error)):
        // TODO: 에러 처리 (토스트 메시지 또는 에러 알림)
        print("Failed to fetch reward progress: \(error)")
        return .none
        
      case .onOpenRewardButtonTapped:
        return .send(.moveToRewardDetail(type: .detail(id: 0)))
        
      case .onWhatIsRewardButtonTapped:
        return .send(.moveToRewardDetail(type: .sample))
        
      case .infoButtonTapped:
        // TODO: 정보 버튼 액션 구현
        return .none
        
      case .onRewardItemTapped(let action):
        switch action {
        case .moveToDetailView(let id):
          return .send(.moveToRewardDetail(type: .detail(id: id)))
        case .showToast(let toastMessage):
          state.toastType = .imageAndText(ImageResource.Icon.gift.image, toastMessage)
          state.isToastPresented = true
          return .none
        }
        
      case .toastPresentedChanged(let isToastPresented):
        state.isToastPresented = isToastPresented
        return .none
        
      case .showToast(let toastType):
        state.toastType = toastType
        return .none
        
      case .moveToRewardDetail(let type):
        state.path.append(.rewardDetail(RewardDetailReducer.State(type: type)))
        return .none
        
      case let .path(action):
        switch action {
        case .element(id: let id, action: .rewardDetail(.backButtonTapped)):
          state.path.pop(from: id)
          return .none
          
        default:
          return .none
        }
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension RewardReducer.Path.State: Equatable {}
