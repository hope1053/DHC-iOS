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
          
          HeaderView(
            level: store.currentLevel,
            levelName: store.currentLevelInfo.name,
            onInfoTapped: {
              store.send(.infoButtonTapped)
            }
          )
          .padding(.bottom, 40)
          
          VStack(spacing: 8) {
            // 메인 리워드 카드
            RewardProgressCard(
              currentPoints: store.currentPoints,
              pointsToNextLevel: store.pointsToNextLevel,
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
}

fileprivate struct HeaderView: View {
  let level: Int
  let levelName: String
  let onInfoTapped: () -> Void
  
  var body: some View {
    // 헤더: 레벨 정보
    HStack(spacing: 8) {
      BadgeView(
        text: "Lv.\(level)",
        textColor: ColorResource.Text.Body.primary.color,
        font: Typography.Head.h7 // TODO: 타이포그라피 피그마 수정 후 반영 필요
      )
      
      Text(levelName)
        .textStyle(.h1)
        .foregroundStyle(LinearGradient(.text02))
      
      Button(action: onInfoTapped) {
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
  let progress: Double
  let levelInfo: [LevelInfo]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 포인트 표시
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
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(ColorResource.Background.glassEffect.color)
      
      // 프로그레스 바
      RewardProgressBar(
        progress: progress,
        pointsToNextLevel: pointsToNextLevel,
        levelInfo: levelInfo
      )
      .padding(.bottom, 32)
    }
    .padding(20)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

// MARK: - RewardProgressBar
struct RewardProgressBar: View {
  let progress: Double
  let pointsToNextLevel: Int
  let levelInfo: [LevelInfo]
  
  var body: some View {
    VStack(spacing: 8) {
      // 말풍선
      GeometryReader { geometry in
        HStack(spacing: 0) {
          Spacer()
            .frame(width: max(0, geometry.size.width * progress - 80))
          
          TooltipView(
            type: .gradient,
            message: "다음 레벨까지 200pt 남았어요"
          )
          
          Spacer()
        }
      }
      .frame(height: 50)
      
      // 프로그레스 바
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // 배경 바
          RoundedRectangle(cornerRadius: 4)
            .fill(ColorResource.Neutral._700.color)
            .frame(height: 8)
          
          // 진행 바
          RoundedRectangle(cornerRadius: 4)
            .fill(
              LinearGradient(
                colors: [
                  ColorResource.Violet._400.color,
                  ColorResource.Violet._200.color
                ],
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .frame(width: geometry.size.width * progress, height: 8)
        }
      }
      .frame(height: 8)
      
      // 레벨 마커
      HStack(spacing: 0) {
        ForEach(Array(levelInfo.enumerated()), id: \.offset) { index, info in
          Text(info.level == -1 ? "Goal" : "lv.\(info.level)")
            .textStyle(.body7)
            .foregroundStyle(ColorResource.Neutral._400.color)
          
          if index < levelInfo.count - 1 {
            Spacer()
          }
        }
      }
    }
  }
}

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
