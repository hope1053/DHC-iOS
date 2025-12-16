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
    var currentPoints: Int = 100
    var currentLevel: Int = 1
    
    var levelInfo: [LevelInfo] = [
      .init(level: 1, name: "새싹 복주머니", threshold: 0),
      .init(level: 4, name: "성장 복주머니", threshold: 300),
      .init(level: 8, name: "풍요 복주머니", threshold: 600),
      .init(level: -1, name: "Goal", threshold: 1000)
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

    init() {
    }
  }

  enum Action {
    // View Action
    case premiumBenefitButtonTapped
    case infoButtonTapped
    
    // Internal Action
    
    // Route Action
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .premiumBenefitButtonTapped:
        // TODO: 프리미엄 혜택 얻기 액션 구현
        return .none
        
      case .infoButtonTapped:
        // TODO: 정보 버튼 액션 구현
        return .none
      }
    }
  }
}

struct LevelInfo: Equatable {
  let level: Int
  let name: String
  let threshold: Int
}
