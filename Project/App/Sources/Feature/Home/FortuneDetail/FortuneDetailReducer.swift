//
//  FortuneDetailReducer.swift
//  Flifin
//
//  Created by 최혜린 on 6/22/25.
//

import ComposableArchitecture

import SwiftUI

enum FortuneDetailType {
  case intro
  case detail
}

@Reducer
struct FortuneDetailReducer {
  @Dependency(\.homeAPIClient) var homeAPIClient
  @Dependency(\.dateFormatterCache) var dateFormatterCache
  
  init() {}

  @ObservableState
  struct State: Equatable {
    let type: FortuneDetailType
    var rawTodayString: String // yyyy-MM-dd 형식
    var formattedTodayString: String // yyyy년 MM월 dd일 형식
    var detailInfo: FortuneDetail?
    var isLoading: Bool

    init(
      type: FortuneDetailType,
      rawTodayString: String = "",
      formattedTodayString: String = "",
      detailInfo: FortuneDetail? = nil,
      isLoading: Bool = false
    ) {
      self.type = type
      self.rawTodayString = rawTodayString
      self.formattedTodayString = formattedTodayString
      self.detailInfo = detailInfo
      self.isLoading = isLoading
    }
  }

  enum Action {
    // View Action
    case onAppear
    case nextButtonTapped
    case backButtonTapped
    
    // Internal Action
    case fetchFortuneDetail
    case fortuneDetailResponse(FortuneDetail)
    case fortuneDetailError(Error)
    case updateTodayDate
    
    // Route Action
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return handleOnAppear(state: &state)
        
      case .nextButtonTapped:
        return .none
        
      case .backButtonTapped:
        return .none
        
      case .fetchFortuneDetail:
        state.isLoading = true
        switch state.type {
        case .detail:
          return .run { [state] send in
            do {
              let fortuneDetail = try await homeAPIClient.fetchFortuneDetail(state.rawTodayString)
              let formattedModel = formatModel(from: fortuneDetail)
              await send(.fortuneDetailResponse(formattedModel))
            } catch {
              await send(.fortuneDetailError(error))
            }
          }
        case .intro:
          state.detailInfo = .introInfo(date: state.formattedTodayString)
          state.isLoading = false
          return .none
        }
        
      case .fortuneDetailResponse(let viewModel):
        state.detailInfo = viewModel
        state.isLoading = false
        return .none
        
      case .fortuneDetailError:
        state.isLoading = false
        return .none
        
      case .updateTodayDate:
        let rawTodayString = dateFormatterCache.formatter(for: "yyyy-MM-dd").string(from: Date())
        let formattedTodayString = dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date())
        state.rawTodayString = rawTodayString
        state.formattedTodayString = formattedTodayString
        return .none
      }
    }
  }
}

extension FortuneDetailReducer {
  private func handleOnAppear(state: inout State) -> Effect<Action> {
    let rawTodayString = dateFormatterCache.formatter(for: "yyyy-MM-dd").string(from: Date())
    let formattedTodayString = dateFormatterCache.formatter(for: "yyyy년 MM월 dd일").string(from: Date())

    state.rawTodayString = rawTodayString
    state.formattedTodayString = formattedTodayString

    switch state.type {
    case .intro:
      if state.detailInfo == nil {
        state.detailInfo = .introInfo(date: formattedTodayString)
      }
      return .none
    case .detail:
      state.detailInfo = nil
      return .send(.fetchFortuneDetail)
    }
  }

  private func formatModel(from model: FortuneDetail) -> FortuneDetail {
    var newModel = model
    
    let date = dateFormatterCache.formatter(for: "yyyy-MM-dd").date(from: model.scoreInfo.date) ?? Date()
    let formattedDate = dateFormatterCache.formatter(for: "yyyy년 M월 d일").string(from: date)
    
    newModel.scoreInfo.date = formattedDate
    
    return newModel
  }
}
