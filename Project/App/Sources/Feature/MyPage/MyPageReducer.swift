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
  @Dependency(\.shareClient) var shareClient
  @Dependency(\.userManager) var userManager
  @Dependency(\.webViewService) var webViewService

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
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
        
        guard let userId = userManager.getUserID() else {
          return .send(.presentWebView(url))
        }
        
        return .run { [shareClient, webViewService] send in
          do {
            let shareCode = try await shareClient.createShareCode(userId)
            
            if let domain = url.host {
              await webViewService.setCookie("shareToken", shareCode, domain)
            } else {
              debugPrint("⚠️ [Share] URL domain을 추출할 수 없음: \(url)")
            }
            
            await send(.presentWebView(url))
          } catch {
            debugPrint("❌ [Share] shareCode 생성 실패: \(error)")
            await send(.presentWebView(url))
          }
        }
        
      case .presentWebView(let url):
        state.path.append(.webView(DHCWebReducer.State(url: url)))
        return .none

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
