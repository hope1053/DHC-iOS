//
//  MyPageReducer.swift
//  Flifin
//
//  Created by Aiden.lee on 6/8/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct MyPageReducer {
  @Dependency(\.myPageClient) var myPageClient
  @Dependency(\.dateFormatterCache) var dateFormatterCache

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var shareTokenCookie = ShareTokenCookieReducer.State()
    var myPageInfo: MyPageInfo
    var isLoading = false
    var isRedacted = false
    
    var fortuneTestList: [MyPageInfo.FortuneTestInfo] {
      myPageInfo.fortuneTestList
    }
    @Presents var appResetAlert: AppResetAlertReducer.State?
  }

  enum Action {
    // View Actions
    case onAppear
    case resetAppButtonTapped
    case fortuneTestRowTapped(url: URL?)
    case presentWebView(URL)
    case shareTokenCookie(ShareTokenCookieReducer.Action)

    // Internal Actions
    case fetchMyPageData
    case myPageDataResponse(MyPageInfo)
    case myPageDataFailed(Error)

    /// Navigation Actions
    case path(StackActionOf<Path>)
    case appResetAlert(PresentationAction<AppResetAlertReducer.Action>)
    case delegate(Delegate)
    enum Delegate {
      case moveToRootView
      case moveToHomeTab
    }
  }
  
  @Reducer
  enum Path {
    case webView(DHCWebReducer)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.shareTokenCookie, action: \.shareTokenCookie) {
      ShareTokenCookieReducer()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard !state.isLoading else {
          return .none
        }

        return .send(.fetchMyPageData)
        
      case .resetAppButtonTapped:
        state.appResetAlert = .init()
        return .none
        
      case .fortuneTestRowTapped(let url):
        guard let url else {
          return .none
        }
        
        return .send(.shareTokenCookie(.prepare(url)))
        
      case .presentWebView(let url):
        state.path.append(.webView(DHCWebReducer.State(url: url)))
        return .none
        
      case .shareTokenCookie(let action):
        switch action {
        case .delegate(.prepared(let url)):
          return .send(.presentWebView(url))
        default:
          return .none
        }

      case .fetchMyPageData:
        state.isLoading = true
        state.isRedacted = true

        return .run { send in
          do {
            let myPageInfo = try await myPageClient.fetchMyPageInfo()
            await send(.myPageDataResponse(myPageInfo))
          } catch {
            await send(.myPageDataFailed(error))
          }
        }

      case .myPageDataResponse(let myPageInfo):
        state.isLoading = false
        state.isRedacted = false
        state.myPageInfo = transform(myPageInfo: myPageInfo)
        return .none

      case .myPageDataFailed:
        state.isLoading = false
        return .none

      case .appResetAlert(.presented(.delegate(.cancel))):
        state.appResetAlert = nil
        return .none

      case .appResetAlert(.presented(.delegate(.resetCompleted))):
        state.appResetAlert = nil
        return .send(.delegate(.moveToRootView))

      case .appResetAlert:
        return .none

      case let .path(action):
        switch action {
        case .element(id: _, action: .webView(.delegate(.close))):
          state.path.removeLast()
          return .none
        case .element(id: _, action: .webView(.delegate(.navigateToMain))):
          state.path.removeLast()
          return .send(.delegate(.moveToHomeTab))
        default:
          return .none
        }

      case .delegate:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$appResetAlert, action: \.appResetAlert) {
      AppResetAlertReducer()
    }
  }

  private func transform(myPageInfo: MyPageInfo) -> MyPageInfo {
    var myPageInfo = myPageInfo

    var formattedBirthDate: String {
      // "2000-01-01" -> "2000년 1월 1일" 형식으로 변환
      if
        let date = dateFormatterCache.formatter(for: "yyyy-MM-dd").date(
          from: myPageInfo.birthDate.date
        )
      {
        return dateFormatterCache.formatter(for: "yyyy년 M월 d일").string(from: date)
      }
      return myPageInfo.birthDate.date
    }

    var formattedBirthTime: String? {
      // "12:00" -> "오후 12시 00분" 형식으로 변환
      if let birthTime = myPageInfo.birthDate.birthTime,
         let time = dateFormatterCache.formatter(for: "HH:mm").date(from: birthTime) {
        let timeFormatter = dateFormatterCache.formatter(for: "a h시 mm분")
        return timeFormatter.string(from: time)
      }
      
      return myPageInfo.birthDate.birthTime
    }

    myPageInfo.birthDate = .init(
      date: formattedBirthDate,
      birthTime: formattedBirthTime
    )

    return myPageInfo
  }
}

extension MyPageReducer.Path.State: Equatable {}
