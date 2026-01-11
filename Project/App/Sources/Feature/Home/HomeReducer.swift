//
//  HomeReducer.swift
//  Flifin
//
//  Created by Aiden.lee on 6/8/25.
//

import SwiftUI

import ComposableArchitecture

@Reducer
struct HomeReducer {
  @Dependency(\.homeAPIClient) var homeAPIClient
  @Dependency(\.dateFormatterCache) var dateFormatterCache
  @Dependency(\.missionTimerClient) var missionTimerClient
  
  private enum CancelID {
    case timer
  }

  @ObservableState
  struct State: Equatable {
    enum ViewState {
      case firstLaunch
      case home
    }

    var viewState: ViewState = .home

    var path = StackState<Path.State>()
    var missionList = MissionListReducer.State(
      longTermMission: HomeInfo.sample.longTermMission,
      todayDailyMissionList: HomeInfo.sample.dailyMissionList,
      isTodayMissionDone: HomeInfo.sample.isTodayMissionDone
    )
    var homeInfo: HomeInfo
    var presentBottomSheet = false
    var presentMissionDonePopup = false
    var presentToast = false
    var testParticipation: TestParticipationReducer.State?

    var fortuneLoadingComplete: FortuneLoadingCompleteReducer.State?
    var isFirstLaunchOfToday: Bool
    var todaySavedMoney: String?
    var toastMessage = ""
    var remainingSeconds: Int = 0
    var completedMissionCount: Int {
      missionList.todayDailyMissionList.filter { $0.isFinished }.count + (missionList.longTermMission.isFinished ? 1 : 0)
    }

    var bottomContentMargin: CGFloat {
      homeInfo.isTodayMissionDone ? 10 : 82
    }

    init(
      homeInfo: HomeInfo,
      fortuneLoadingComplete: FortuneLoadingCompleteReducer.State? = nil,
      isFirstLaunchOfToday: Bool
    ) {
      self.homeInfo = homeInfo
      self.fortuneLoadingComplete = fortuneLoadingComplete
      self.isFirstLaunchOfToday = isFirstLaunchOfToday
      // 나중에 실제 구현할 때는 init에서 self.testParticipation = nil로 변경하고, 특정 조건에서만 표시되도록 하면 됩니다!
      self.testParticipation = TestParticipationReducer.State(
        test: homeInfo.availableTest
      )
    }
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Actions
    case onAppear

    case presentBottomSheet(Bool)
    case confirmTodayMissionDoneButtonTapped
    case cancelTodayMissionDoneButtonTapped
    case rewardButtonTapped

    case popupConfirmButtonTapped
    case popupDismissButtonTapped

    case presentToast(String)
    case setToastPresented(Bool)
    
    case startTimer
    case timerTicked(Int)
    
    case presentTestParticipation(Bool)

    // Internal Actions
    case fetchHomeData
    case homeDataResponse(HomeInfo)
    case homeDataFailed(Error)
    case todayMissionDoneResponse(String)
    case missionList(MissionListReducer.Action)
    case fortuneLoadingComplete(FortuneLoadingCompleteReducer.Action)
    case testParticipation(TestParticipationReducer.Action)

    // Navigation Actions
    case path(StackActionOf<Path>)
    case moveToFortuneDetail
    case delegate(Delegate)
    enum Delegate {
      case moveToReportTab
    }
  }

  @Reducer
  enum Path {
    case fortuneDetail(FortuneDetailReducer)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.missionList, action: \.missionList) {
      MissionListReducer()
    }

    Reduce(core)
      .forEach(\.path, action: \.path)
      .ifLet(\.fortuneLoadingComplete, action: \.fortuneLoadingComplete) {
        FortuneLoadingCompleteReducer()
      }
      .ifLet(\.testParticipation, action: \.testParticipation) {
        TestParticipationReducer()
      }
  }
  
  private func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .binding:
      return .none
      
    case .onAppear:
      return handleOnAppear(state: &state)
    
    case .startTimer:
      return handleStartTimer()
    
    case .timerTicked(let seconds):
      state.remainingSeconds = seconds
      return .none

    case .presentBottomSheet(let isVisible):
      state.presentBottomSheet = isVisible
      return .none

    case .presentToast(let toastMessage):
      return handlePresentToast(state: &state, message: toastMessage)

    case .setToastPresented(let isPresented):
      state.presentToast = isPresented
      return .none

    case .confirmTodayMissionDoneButtonTapped:
      return handleConfirmTodayMissionDone(state: &state)

    case .cancelTodayMissionDoneButtonTapped:
      state.presentBottomSheet = false
      return .none
      
    case .rewardButtonTapped:
      // TODO
      return .none

    case .popupConfirmButtonTapped:
      state.presentMissionDonePopup = false
      return .send(.delegate(.moveToReportTab))

    case .popupDismissButtonTapped:
      state.presentMissionDonePopup = false
      return .none

    case .fetchHomeData:
      return handleFetchHomeData()

    case .homeDataResponse(let homeInfo):
      return handleHomeDataResponse(state: &state, homeInfo: homeInfo)

    case .homeDataFailed:
      return .none

    case .missionList(let action):
      return handleMissionListAction(action)

    case .fortuneLoadingComplete(let action):
      return handleFortuneLoadingCompleteAction(state: &state, action: action)

    case .moveToFortuneDetail:
      state.path.append(.fortuneDetail(FortuneDetailReducer.State(type: .detail)))
      return .none

    case let .path(action):
      return handlePathAction(state: &state, action: action)

    case .delegate:
      return .none

    case .todayMissionDoneResponse(let todaySavedMoney):
      state.todaySavedMoney = todaySavedMoney
      return .none
      
    case .presentTestParticipation(let isPresented):
      return handlePresentTestParticipation(state: &state, isPresented: isPresented)
      
    case .testParticipation(let action):
      return handleTestParticipationAction(action)
    }
  }
  
  private func handleOnAppear(state: inout State) -> Effect<Action> {
    if state.isFirstLaunchOfToday {
      withAnimation(.easeInOut(duration: 0.5)) {
        state.viewState = .firstLaunch
      }
    } else {
      state.viewState = .home
    }

    return .merge(
      .send(.fetchHomeData),
      .send(.startTimer)
    )
  }
  
  private func handleStartTimer() -> Effect<Action> {
    return .run { send in
      for await remaining in missionTimerClient.timerStream() {
        await send(.timerTicked(remaining))
      }
    }
    .cancellable(id: CancelID.timer, cancelInFlight: true)
  }
  
  private func handlePresentToast(state: inout State, message: String) -> Effect<Action> {
    state.toastMessage = message
    state.presentToast = true

    return .run { send in
      try await Task.sleep(for: .seconds(1.5))
      await send(.setToastPresented(false))
    }
  }
  
  private func handleConfirmTodayMissionDone(state: inout State) -> Effect<Action> {
    state.presentBottomSheet = false
    state.presentMissionDonePopup = true

    let todayDate = formattedTodayDate()

    return .run { [homeAPIClient] send in
      do {
        let todaySavedMoney = try await homeAPIClient.todayMissionDone(todayDate)
        await send(.todayMissionDoneResponse(todaySavedMoney))
        await send(.fetchHomeData)
      } catch {
        #if DEBUG
        print("오늘 미션 완료 처리 실패")
        #endif
      }
    }
  }
  
  private func handleFetchHomeData() -> Effect<Action> {
    return .run { [homeAPIClient] send in
      do {
        let homeInfo = try await homeAPIClient.fetchHomeInfo()
        await send(.homeDataResponse(homeInfo))
      } catch {
        await send(.homeDataFailed(error))
      }
    }
  }
  
  private func handleHomeDataResponse(state: inout State, homeInfo: HomeInfo) -> Effect<Action> {
    if state.isFirstLaunchOfToday {
      let dailyFortune = homeInfo.dailyFortune
      let scoreInfo = FortuneDetail.FortuneScore(
        date: formatDate(from: dailyFortune.date),
        scoreString: "\(dailyFortune.score)점",
        score: dailyFortune.score,
        summary: dailyFortune.title
      )
      let cardInfo = FortuneDetail.FortuneCard(
        backgroundImageURL: dailyFortune.cardImageURL,
        title: dailyFortune.cardTitle,
        fortune: dailyFortune.cardSubTitle
      )
      state.fortuneLoadingComplete = .init(
        scoreInfo: scoreInfo,
        cardInfo: cardInfo
      )

      withAnimation(.easeInOut(duration: 0.5)) {
        state.viewState = .firstLaunch
      }
      return .none
    } else {
      state.homeInfo = homeInfo
      return .merge(
        .send(.missionList(.updateLongTermMission(homeInfo.longTermMission))),
        .send(.missionList(.updateDailyMissions(homeInfo.dailyMissionList))),
        .send(.missionList(.updateTodayMissionDone(homeInfo.isTodayMissionDone)))
      )
    }
  }
  
  private func handleMissionListAction(_ action: MissionListReducer.Action) -> Effect<Action> {
    switch action {
    case .delegate(.presentToast(let message)):
      return .send(.presentToast(message))
    default:
      return .none
    }
  }
  
  private func handleFortuneLoadingCompleteAction(state: inout State, action: FortuneLoadingCompleteReducer.Action) -> Effect<Action> {
    switch action {
    case .delegate(.moveToHome):
      state.isFirstLaunchOfToday.toggle()
      withAnimation(.easeInOut(duration: 0.5)) {
        state.viewState = .home
      }
      return .none
    default:
      return .none
    }
  }
  
  private func handlePathAction(state: inout State, action: StackActionOf<Path>) -> Effect<Action> {
    switch action {
    case .element(id: let id, action: .fortuneDetail(.backButtonTapped)):
      state.path.pop(from: id)
      return .none
    default:
      return .none
    }
  }
  
  private func handlePresentTestParticipation(state: inout State, isPresented: Bool) -> Effect<Action> {
    if isPresented {
      state.testParticipation = TestParticipationReducer.State(test: state
        .homeInfo.availableTest)
    } else {
      state.testParticipation = nil
    }
    return .none
  }
  
  private func handleTestParticipationAction(_ action: TestParticipationReducer.Action) -> Effect<Action> {
    switch action {
    case .delegate(.dismiss):
      return .send(.presentTestParticipation(false))
    case .delegate(.participate):
      // TODO: 테스트 참여 로직 구현
      return .send(.presentTestParticipation(false))
    default:
      return .none
    }
  }

  private func formatDate(from dateString: String) -> String {
    let date = dateFormatterCache.formatter(for: "yyyy-MM-dd").date(from: dateString) ?? Date()
    let formattedString = dateFormatterCache.formatter(for: "yyyy년 M월 d일").string(from: date)
    return formattedString
  }

  private func formattedTodayDate() -> String {
    let formatter = dateFormatterCache.formatter(for: "yyyy-MM-dd")
    return formatter.string(from: Date())
  }
}

extension HomeReducer.Path.State: Equatable {}
