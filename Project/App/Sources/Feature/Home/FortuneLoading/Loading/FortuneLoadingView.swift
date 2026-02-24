//
//  FortuneLoadingView.swift
//  Flifin
//
//  Created by hyerin on 7/2/25.
//

import SwiftUI

import ComposableArchitecture

struct FortuneLoadingView: View {
  let store: StoreOf<FortuneLoadingReducer>
  private let badgeText: String?
  private let loadingMessage: String
  
  init(
    store: StoreOf<FortuneLoadingReducer>,
    badgeText: String? = nil,
    loadingMessage: String = "오늘의 운세를 카드에 담고 있어요.."
  ) {
    self.store = store
    self.badgeText = badgeText
    self.loadingMessage = loadingMessage
  }
  
  var body: some View {
    mainView
    .overlay(alignment: .top) {
      VStack(spacing: 8) {
        BadgeView(
          text: badgeText ?? store.todayDateString,
          textColor: ColorResource.Text.Body.primary.color,
          font: Typography.Body.body6
        )
        
        Text(loadingMessage)
          .foregroundStyle(ColorResource.Text.Body.primary.color)
          .textStyle(.h4)
      }
      .padding(.top, 84)
    }
    .onAppear {
      store.send(.onAppear)
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var mainView: some View {
    if store.shouldPlayVideo {
      LoopingVideoPlayer(
        videoURL: .urlForResource(.fortuneLoadingVideo)!,
        needSoundMute: true
      )
      .disabled(true)
      .ignoresSafeArea()
    } else {
      ImageResource.fortuneLoadingThumbnail.image
        .ignoresSafeArea()
    }
  }
}

#Preview {
  FortuneLoadingView(
    store: Store(
      initialState: .init(),
      reducer: FortuneLoadingReducer.init
    )
  )
}
