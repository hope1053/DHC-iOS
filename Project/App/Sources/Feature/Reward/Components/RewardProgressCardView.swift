//
//  RewardProgressCardView.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import SwiftUI

struct RewardProgressCardView: View {
  private let currentPoints: Int
  private let pointsToNextLevel: Int
  private let currentLevel: Int
  private let progress: Double
  private let levelInfo: [LevelInfo]
  private let onOpenRewardButtonTapped: () -> Void
  private let onWhatIsRewardButtonTapped: () -> Void
  
  init(
    currentPoints: Int,
    pointsToNextLevel: Int,
    currentLevel: Int,
    progress: Double,
    levelInfo: [LevelInfo],
    onOpenRewardButtonTapped: @escaping () -> Void,
    onWhatIsRewardButtonTapped: @escaping () -> Void
  ) {
    self.currentPoints = currentPoints
    self.pointsToNextLevel = pointsToNextLevel
    self.currentLevel = currentLevel
    self.progress = progress
    self.levelInfo = levelInfo
    self.onOpenRewardButtonTapped = onOpenRewardButtonTapped
    self.onWhatIsRewardButtonTapped = onWhatIsRewardButtonTapped
  }
  
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
      
      CTAButton(
        size: .large,
        style: .primary,
        title: "리워드 열기",
        action: onOpenRewardButtonTapped
      )
      .disabled(true)
      
      Text("리워드는 뭔가요? >")
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .textStyle(.body5)
        .foregroundStyle(ColorResource.Text.Highlights.secondary.color)
        .underline()
        .onTapGesture {
          onWhatIsRewardButtonTapped()
        }
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
