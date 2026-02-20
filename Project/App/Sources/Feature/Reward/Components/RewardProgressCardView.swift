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
  private let currentLevel: LevelInfo
  private let rewardStatus: RewardStatus
  private let totalSteps: Int
  private let onOpenRewardButtonTapped: () -> Void
  private let onWhatIsRewardButtonTapped: () -> Void
  
  init(
    currentPoints: Int,
    pointsToNextLevel: Int,
    currentLevel: LevelInfo,
    rewardStatus: RewardStatus,
    totalSteps: Int,
    onOpenRewardButtonTapped: @escaping () -> Void,
    onWhatIsRewardButtonTapped: @escaping () -> Void
  ) {
    self.currentPoints = currentPoints
    self.pointsToNextLevel = pointsToNextLevel
    self.currentLevel = currentLevel
    self.rewardStatus = rewardStatus
    self.totalSteps = totalSteps
    self.onOpenRewardButtonTapped = onOpenRewardButtonTapped
    self.onWhatIsRewardButtonTapped = onWhatIsRewardButtonTapped
  }

  private var rewardButtonTitle: String {
    switch rewardStatus {
    case .opened:
      return "리워드 수령 완료"
    case .openable, .notOpened:
      return "리워드 열기"
    }
  }

  private var isRewardButtonEnabled: Bool {
    switch rewardStatus {
    case .openable:
      return true
    case .opened, .notOpened:
      return false
    }
  }
  
  private var milestones: [Milestone] {
    (1...totalSteps).map { level in
      Milestone(
        level: level,
        title: "\(level)",
        type: level == totalSteps ? .image(ImageResource.Icon.gift.image) : .dot
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
        title: rewardButtonTitle,
        action: onOpenRewardButtonTapped
      )
      .disabled(!isRewardButtonEnabled)
      
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
    VStack(spacing: 12) {
      // 툴팁
      TooltipView(
        type: .rewardGradient,
        message: "다음 레벨까지 \(pointsToNextLevel)pt 남았어요",
        expandWidth: true
      )
      .frame(maxWidth: .infinity)
      
      // ProgressView
      StepProgressView(
        milestones: milestones,
        currentLevel: currentLevel.level
      )
    }
  }
}
