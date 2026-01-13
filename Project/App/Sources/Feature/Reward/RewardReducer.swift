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
  case moveToDetailView(String)
}

@Reducer
struct RewardReducer {
  init() {}

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var rewardInfo: RewardInfo = .initial
    var toastType: ToastType = .textWithCheck("")
    var isToastPresented: Bool = false

    init() {
    }
  }

  enum Action {
    // View Action
    case onOpenRewardButtonTapped
    case onWhatIsRewardButtonTapped
    case infoButtonTapped
    case onRewardItemTapped(action: ReceivedRewardAction)
    case toastPresentedChanged(Bool)
    
    // Internal Action
    case showToast(ToastType)
    
    // Route Action
    case path(StackActionOf<Path>)
    case moveToRewardDetail
  }
  
  @Reducer
  enum Path {
    case rewardDetail(RewardDetailReducer)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onOpenRewardButtonTapped:
        return .send(.moveToRewardDetail)
        
      case .onWhatIsRewardButtonTapped:
        // TODO: 리워드는 뭔가요? > 버튼 액션 구현
        return .none
        
      case .infoButtonTapped:
        // TODO: 정보 버튼 액션 구현
        return .none
        
      case .onRewardItemTapped(let action):
        switch action {
        case .moveToDetailView:
          return .send(.moveToRewardDetail)
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
        
      case .moveToRewardDetail:
        state.path.append(.rewardDetail(RewardDetailReducer.State()))
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
