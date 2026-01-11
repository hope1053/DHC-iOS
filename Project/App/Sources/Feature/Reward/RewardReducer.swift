//
//  RewardReducer.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct RewardReducer {
  init() {}

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    
    var currentPoints: Int = 100
    var currentLevel: Int = 1
    
    var levelInfo: [LevelInfo] = [
      .init(level: 1, name: "Lv.1", threshold: 0),
      .init(level: 2, name: "Lv.2", threshold: 100),
      .init(level: 3, name: "Lv.3", threshold: 200),
      .init(level: 4, name: "Lv.4", threshold: 300),
      .init(level: 5, name: "Lv.5", threshold: 400),
      .init(level: 6, name: "Lv.6", threshold: 500),
      .init(level: 7, name: "Lv.7", threshold: 600),
      .init(level: 8, name: "Lv.8", threshold: 700)
    ]
    
    var currentLevelInfo: LevelInfo {
      levelInfo.first(where: { $0.level == currentLevel }) ?? levelInfo[0]
    }
    
    var nextLevelInfo: LevelInfo? {
      guard let currentIndex = levelInfo.firstIndex(where: { $0.level == currentLevel }),
            currentIndex + 1 < levelInfo.count else {
        return nil
      }
      return levelInfo[currentIndex + 1]
    }
    
    var pointsToNextLevel: Int {
      guard let nextLevel = nextLevelInfo else { return 0 }
      return nextLevel.threshold - currentPoints
    }
    
    var progress: Double {
      guard let nextLevel = nextLevelInfo else { return 1.0 }
      let currentThreshold = currentLevelInfo.threshold
      let nextThreshold = nextLevel.threshold
      let range = Double(nextThreshold - currentThreshold)
      guard range > 0 else { return 1.0 }
      let currentProgress = Double(currentPoints - currentThreshold)
      return min(max(currentProgress / range, 0), 1.0)
    }
    
    var receivedRewards: [RewardItem] = [
      .init(
        title: "1년 운세",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        title: "전반적 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        title: "복합 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: nil
      )
    ]
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

struct LevelInfo: Equatable {
  let level: Int
  let name: String
  let threshold: Int
}

extension RewardReducer.Path.State: Equatable {}
