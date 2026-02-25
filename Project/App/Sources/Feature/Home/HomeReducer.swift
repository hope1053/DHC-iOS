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
  @Dependency(\.testBannerStorage) var testBannerStorage
  
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
    var todayMissionResult: MissionResult?
    var presentToast = false
    var testParticipation: TestParticipationReducer.State? = nil

    var fortuneLoadingComplete: FortuneLoadingCompleteReducer.State?
    var isFirstLaunchOfToday: Bool
    var toastMessage = ""
    var shareTokenCookie = ShareTokenCookieReducer.State()
    var remainingSeconds: Int = 0
    var completedMissionCount: Int {
      let completedDailyMissionCount = missionList.todayDailyMissionList
        .filter { $0.isFinished && $0.type != .love }
        .count
      let completedLongTermMissionCount =
        missionList.longTermMission.isFinished && missionList.longTermMission.type != .love ? 1 : 0

      return completedDailyMissionCount + completedLongTermMissionCount
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

    case popupFirstButtonTapped
    case popupSecondButtonTapped
    case popupDismissButtonTapped

    case presentToast(String)
    case setToastPresented(Bool)
    
    case startTimer
    case timerTicked(Int)
    
    case presentWebView(URL)
    case shareTokenCookie(ShareTokenCookieReducer.Action)

    // Internal Actions
    case fetchHomeData
    case homeDataResponse(HomeInfo)
    case homeDataFailed(Error)
    case todayMissionDoneResponse(TodayMissionStatus)
    case missionList(MissionListReducer.Action)
    case fortuneLoadingComplete(FortuneLoadingCompleteReducer.Action)
    case testParticipation(TestParticipationReducer.Action)

    // Navigation Actions
    case path(StackActionOf<Path>)
    case moveToFortuneDetail
    case delegate(Delegate)
    enum Delegate {
      case moveToReportTab
      case moveToRewardTab
    }
  }

  @Reducer
  enum Path {
    case fortuneDetail(FortuneDetailReducer)
    case webView(DHCWebReducer)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.missionList, action: \.missionList) {
      MissionListReducer()
    }
    Scope(state: \.shareTokenCookie, action: \.shareTokenCookie) {
      ShareTokenCookieReducer()
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
      return .send(.delegate(.moveToRewardTab))

      // MARK: - 팝업
    case .popupFirstButtonTapped:
      guard let popupType = state.todayMissionResult else {
        return .none
      }
      
      switch popupType {
      case .todaySuccess:
        state.presentMissionDonePopup = false
        return .send(.delegate(.moveToRewardTab))
      case .todayFail:
        state.presentMissionDonePopup = false
        return .none
      default:
        return .none
      }
      
    case .popupSecondButtonTapped:
      guard let popupType = state.todayMissionResult else {
        return .none
      }
      
      switch popupType {
      case .todaySuccess:
        state.presentMissionDonePopup = false
        return .none
      default:
        return .none
      }
      
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

    case .todayMissionDoneResponse(let todayMissionStatus):
      if todayMissionStatus.isMissionSuccess {
        state.todayMissionResult = .todaySuccess(earnedPoint: todayMissionStatus.earnedPoint)
      } else {
        state.todayMissionResult = .todayFail
      }
      
      state.presentMissionDonePopup = true
      return .none
      
    case .testParticipation(let action):
      return handleTestParticipationAction(state: &state, action)
      
    case .presentWebView(let url):
      state.path.append(.webView(DHCWebReducer.State(url: url)))
      return .none

    case .shareTokenCookie(let action):
      return handleShareTokenCookieAction(action)
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

    let todayDate = formattedTodayDate()

    return .run { [homeAPIClient] send in
      do {
        let todayMissionStatus = try await homeAPIClient.todayMissionDone(todayDate)
        await send(.todayMissionDoneResponse(todayMissionStatus))
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
    state.homeInfo = homeInfo
    
    // pastMissionStatus를 MissionResult로 변환
    // 단, 이미 today 관련 popupType이 설정되어 있으면 덮어쓰지 않음
    if case .todaySuccess = state.todayMissionResult {
      // todayMissionDone 직후 fetchHomeData가 호출된 경우, today 상태 유지
    } else if case .todayFail = state.todayMissionResult {
      // todayMissionDone 직후 fetchHomeData가 호출된 경우, today 상태 유지
    } else {
      // 일반적인 경우, 서버의 pastMissionStatus로 업데이트
      state.todayMissionResult = MissionResult(from: homeInfo.pastMissionStatus)
    }
    
    // 닫힌 버전 필터링: availableTest가 있고 해당 버전이 닫힌 버전에 없는 경우에만 표시
    let dismissedVersions = testBannerStorage.getDismissedVersions()
    if let test = homeInfo.availableTest,
       !dismissedVersions.contains(test.version) {
      state.testParticipation = TestParticipationReducer.State(test: test)
    } else {
      state.testParticipation = nil
    }
    
    let missionListUpdateEffect: Effect<Action> = .merge(
      .send(.missionList(.updateLongTermMission(homeInfo.longTermMission))),
      .send(.missionList(.updateDailyMissions(homeInfo.dailyMissionList))),
      .send(.missionList(.updateTodayMissionDone(homeInfo.isTodayMissionDone)))
    )
    
    if state.isFirstLaunchOfToday {
      let dailyFortune = homeInfo.dailyFortune
      let scoreInfo = FortuneDetail.FortuneScore(
        date: formatDate(from: dailyFortune.date),
        scoreString: "\(dailyFortune.score)점",
        score: dailyFortune.score,
        summary: dailyFortune.title
      )
      let cardInfo = FortuneCard(
        backgroundImageURL: dailyFortune.cardImageURL,
        title: dailyFortune.cardTitle,
        fortune: dailyFortune.cardSubTitle
      )
      let missionResult = MissionResult(from: homeInfo.pastMissionStatus)
      
      state.fortuneLoadingComplete = .init(
        scoreInfo: scoreInfo,
        cardInfo: cardInfo,
        missionResult: missionResult
      )

      withAnimation(.easeInOut(duration: 0.5)) {
        state.viewState = .firstLaunch
      }
      return missionListUpdateEffect
    } else {
      return missionListUpdateEffect
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
    case .delegate(.moveToReward):
      state.isFirstLaunchOfToday.toggle()
      withAnimation(.easeInOut(duration: 0.5)) {
        state.viewState = .home
      }
      return .send(.delegate(.moveToRewardTab))
    default:
      return .none
    }
  }
  
  private func handlePathAction(state: inout State, action: StackActionOf<Path>) -> Effect<Action> {
    switch action {
    case .element(id: let id, action: .fortuneDetail(.backButtonTapped)):
      state.path.pop(from: id)
      return .none
    case .element(id: _, action: .webView(.delegate(.close))):
      state.path.removeLast()
      return .none
    case .element(id: _, action: .webView(.delegate(.navigateToMain))):
      state.path.removeLast()
      return .none
    default:
      return .none
    }
  }
  
  private func handleTestParticipationAction(state: inout State, _ action: TestParticipationReducer.Action) -> Effect<Action> {
    switch action {
    case .delegate(.dismissBanner):
      state.testParticipation = nil
      return .none
    case .delegate(.participate(let url)):
      state.testParticipation = nil
      
      guard let url else {
        return .none
      }
      
      return .send(.shareTokenCookie(.prepare(url)))
    default:
      return .none
    }
  }
  
  private func handleShareTokenCookieAction(_ action: ShareTokenCookieReducer.Action) -> Effect<Action> {
    switch action {
    case .delegate(.prepared(let url)):
      return .send(.presentWebView(url))
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
