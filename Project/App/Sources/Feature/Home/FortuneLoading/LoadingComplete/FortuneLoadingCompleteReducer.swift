//
//  FortuneLoadingCompleteReducer.swift
//  Flifin
//
//  Created by 최혜린 on 7/2/25.
//

import ComposableArchitecture

@Reducer
struct FortuneLoadingCompleteReducer {
  @Dependency(\.launchManager) var launchManager
  
  init() {}

  @ObservableState
  struct State: Equatable {
    var isCardFlipped: Bool
    let scoreInfo: FortuneDetail.FortuneScore
    let cardInfo: FortuneDetail.FortuneCard
    let missionResult: MissionResult?
    var presentMissionResultPopup: Bool

    init(
      isCardFlipped: Bool = false,
      scoreInfo: FortuneDetail.FortuneScore,
      cardInfo: FortuneDetail.FortuneCard,
      missionResult: MissionResult? = nil
    ) {
      self.isCardFlipped = isCardFlipped
      self.scoreInfo = scoreInfo
      self.cardInfo = cardInfo
      self.missionResult = missionResult
      self.presentMissionResultPopup = missionResult != nil
    }
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    // View Action
    case cardFlipped
    case popupFirstButtonTapped
    case popupSecondButtonTapped
    case popupDismissButtonTapped
    
    // Internal Action
    
    // Route Action
    case delegate(Delegate)
    enum Delegate {
      case moveToHome
      case moveToReward
    }
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .cardFlipped:
        state.isCardFlipped = true
        launchManager.setLastLaunchDate()
        
        return .run { send in
          do {
            try await Task.sleep(for: .seconds(1.5))
            await send(.delegate(.moveToHome))
          } catch {}
        }
        
      case .popupFirstButtonTapped:
        guard let missionResult = state.missionResult else {
          return .none
        }
        
        switch missionResult {
        case .yesterDaySuccess:
          state.presentMissionResultPopup = false
          return .send(.delegate(.moveToReward))
        case .yesterDayFail, .fewDaysFail:
          state.presentMissionResultPopup = false
          return .none
        default:
          return .none
        }
        
      case .popupSecondButtonTapped:
        guard let missionResult = state.missionResult else {
          return .none
        }
        
        switch missionResult {
        case .yesterDaySuccess:
          state.presentMissionResultPopup = false
          return .none
        default:
          return .none
        }
        
      case .popupDismissButtonTapped:
        state.presentMissionResultPopup = false
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
