//
//  RewardView.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

import ComposableArchitecture

struct RewardView: View {
  @Bindable var store: StoreOf<RewardReducer>
  
  init(store: StoreOf<RewardReducer>) {
    self.store = store
  }
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: 0) {
        DHCNavigationBar(type: .title("리워드"))
          .padding(.bottom, 24)
        
        ScrollView {
          VStack(spacing: 0) {
            placeholderGraphic
              .padding(.bottom, 25)
            
            headerView
            .padding(.bottom, 40)
            
            VStack(spacing: 8) {
              // 메인 리워드 카드
              if let userInfo = store.userProgressInfo,
                 let rewardInfo = store.rewardInfo {
                RewardProgressCardView(
                  currentPoints: userInfo.currentPoints,
                  pointsToNextLevel: userInfo.pointsToNextLevel,
                  currentLevel: userInfo.currentLevel,
                  totalSteps: rewardInfo.totalLevel,
                  onOpenRewardButtonTapped: {
                    store.send(.onOpenRewardButtonTapped)
                  },
                  onWhatIsRewardButtonTapped: {
                    store.send(.onWhatIsRewardButtonTapped)
                  }
                )
                
                ReceivedRewardView(
                  rewards: rewardInfo.receivedRewards,
                  onRewardItemTapped: { action in
                    store.send(.onRewardItemTapped(action: action))
                  }
                )
                .padding(.bottom, 72)
              }
            }
          }
        }
        .padding(.horizontal, 20)
      }
      .scrollIndicators(.hidden)
      .radialGradientBackground(
        type: .backgroundGradient02,
        endRadiusMultiplier: 1.2,
        scaleEffectX: 1.8
      )
      .background(ColorResource.Background.main.color)
      .toast(
        isPresented: $store.isToastPresented.sending(\.toastPresentedChanged),
        type: store.toastType
      )
      .onAppear {
        store.send(.onAppear)
      }
    } destination: { store in
      switch store.case {
      case .yearlyFortune(let store):
        YearlyFortuneView(store: store)
      }
    }
  }
  
  private var placeholderGraphic: some View {
    VStack {
      Text("그래픽 (변경예정)")
        .textStyle(.body3)
        .foregroundStyle(ColorResource.Neutral._500.color)
    }
    .frame(height: 120)
  }
  
  var headerView: some View {
    HStack(spacing: 8) {
      if let userProgressInfo = store.userProgressInfo {
        BadgeView(
          text: "Lv.\(userProgressInfo.currentLevel.level)",
          textColor: ColorResource.Text.Body.primary.color,
          font: Typography.Head.h8
        )
        
        Text(userProgressInfo.currentLevel.name)
          .textStyle(.h1)
          .foregroundStyle(LinearGradient(.text02))
      }
      
      Button {
        store.send(.infoButtonTapped)
      } label: {
        Image(.Icon.info)
          .resizable()
          .renderingMode(.template)
          .frame(width: 20, height: 20)
          .foregroundStyle(ColorResource.Neutral._400.color)
      }
    }
    .padding(.bottom, 20)
  }
}
