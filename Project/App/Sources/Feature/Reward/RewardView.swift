//
//  RewardView.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

import ComposableArchitecture

struct RewardView: View {
  let store: StoreOf<RewardReducer>
  
  init(store: StoreOf<RewardReducer>) {
    self.store = store
  }
  
  var body: some View {
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
            RewardProgressCard(
              currentPoints: store.currentPoints,
              pointsToNextLevel: store.pointsToNextLevel,
              currentLevel: store.currentLevel,
              progress: store.progress,
              levelInfo: store.levelInfo
            )
            
            PreminumCard(
              onPremiumButtonTapped: {
                store.send(.premiumBenefitButtonTapped)
              }
            )
            .padding(.bottom, 72)
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
      BadgeView(
        text: "Lv.\(store.currentLevel)",
        textColor: ColorResource.Text.Body.primary.color,
        font: Typography.Head.h8
      )
      
      Text(store.currentLevelInfo.name)
        .textStyle(.h1)
        .foregroundStyle(LinearGradient(.text02))
      
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

// MARK: - RewardProgressCard
struct RewardProgressCard: View {
  let currentPoints: Int
  let pointsToNextLevel: Int
  let currentLevel: Int
  let progress: Double
  let levelInfo: [LevelInfo]
  
  private var totalSteps: Int {
    // levelInfo에서 -1이 아닌 가장 큰 level 찾기
    levelInfo.filter { $0.level != -1 }.map { $0.level }.max() ?? 10
  }
  
  private var milestones: [Milestone] {
    levelInfo.map { info in
      Milestone(
        level: info.level,
        title: info.level == -1 ? "Goal" : "Lv.\(info.level)"
      )
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      progressTopSection
      
      dividerView
      
      progressBottomSection
    }
    .padding(20)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  var progressTopSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("지금까지 얻은 리워드")
        .textStyle(.body5)
        .foregroundStyle(ColorResource.Neutral._300.color)
      
      HStack(alignment: .firstTextBaseline, spacing: 4) {
        Text("\(currentPoints)")
          .textStyle(.h1)
          .foregroundStyle(ColorResource.Text.main.color)
        
        Text("pt")
          .textStyle(.body1)
          .foregroundStyle(ColorResource.Neutral._300.color)
      }
    }
  }
  
  var dividerView: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundStyle(ColorResource.Background.glassEffect.color)
  }
  
  var progressBottomSection: some View {
    VStack(spacing: 8) {
      // 툴팁
      tooltipView
      
      // ProgressView
      ProgressView(
        totalSteps: totalSteps,
        currentLevel: currentLevel,
        milestones: milestones
      )
    }
  }
  
  private var tooltipView: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        Spacer()
          .frame(width: max(0, geometry.size.width * progress - 80))
        
        TooltipView(
          type: .gradient,
          message: "다음 레벨까지 \(pointsToNextLevel)pt 남았어요"
        )
        
        Spacer()
      }
    }
    .frame(height: 50)
  }
}

// MARK: - PreminumCard
struct PreminumCard: View {
  private let onPremiumButtonTapped: () -> Void
  
  init(onPremiumButtonTapped: @escaping () -> Void) {
    self.onPremiumButtonTapped = onPremiumButtonTapped
  }
  
  private var goalDescriptionText: AttributedString {
    var attributedString = AttributedString("Goal에 도달하면 프리미엄 운세를 볼 수 있어요")
    
    // 전체 문자열에 기본 스타일 적용
    attributedString.font = Typography.Body.body5.font
    attributedString.foregroundColor = ColorResource.Neutral._300.color
    
    // Goal 부분만 특정 스타일로 오버라이드
    if let goalRange = attributedString.range(of: "Goal") {
      attributedString[goalRange].font = Typography.Head.h7.font
      attributedString[goalRange].foregroundColor = ColorResource.Text.Highlights.primary.color
    }
    
    return attributedString
  }
  
  var body: some View {
    VStack(spacing: 16) {
      // 선물 아이콘
      ImageResource.Icon.gift.image
        .resizable()
        .frame(width: 40, height: 40)
      
      // 설명 텍스트
      Text(goalDescriptionText)
      
      // CTA 버튼
      CTAButton(
        size: .large,
        style: .secondary,
        title: "프리미엄 운세 열기",
        action: onPremiumButtonTapped
      )
      .disabled(true)
    }
    .padding(20)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
