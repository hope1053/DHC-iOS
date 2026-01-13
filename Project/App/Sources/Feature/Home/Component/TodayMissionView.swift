//
//  TodayMissionView.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import SwiftUI

struct TodayMissionView: View, Equatable {
  private let remainingSeconds: Int
  private let completedMissionCount: Int
  private let didTapRewardButton: () -> Void
  private let showCollectedRewardButtonTapped: () -> Void
  private let getRewardButtonTapped: () -> Void
  
  init(
    remainingSeconds: Int,
    completedMissionCount: Int,
    didTapRewardButton: @escaping () -> Void,
    showCollectedRewardButtonTapped: @escaping () -> Void,
    getRewardButtonTapped: @escaping () -> Void
  ) {
    self.remainingSeconds = remainingSeconds
    self.completedMissionCount = completedMissionCount
    self.didTapRewardButton = didTapRewardButton
    self.showCollectedRewardButtonTapped = showCollectedRewardButtonTapped
    self.getRewardButtonTapped = getRewardButtonTapped
  }
  
  static func == (lhs: TodayMissionView, rhs: TodayMissionView) -> Bool {
    lhs.remainingSeconds == rhs.remainingSeconds &&
    lhs.completedMissionCount == rhs.completedMissionCount
  }
  
  var body: some View {
    VStack(spacing: 24) {
      TodayMissionTimerView(remainingSeconds: remainingSeconds)
        .equatable()
      
      MissionProgressView(
        completedMissionCount: completedMissionCount,
        totalMissionCount: 3,
        onRewardTapped: didTapRewardButton,
        showCollectedRewardButtonTapped: showCollectedRewardButtonTapped,
        getRewardButtonTapped: getRewardButtonTapped
      )
      .equatable()
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
    .padding(.bottom, 40)
  }
}

// MARK: - MissionProgressView
struct MissionProgressView: View, Equatable {
  private let completedMissionCount: Int
  private let totalMissionCount: Int
  private let onRewardTapped: () -> Void
  private let showCollectedRewardButtonTapped: () -> Void
  private let getRewardButtonTapped: () -> Void
  
  init(
    completedMissionCount: Int,
    totalMissionCount: Int,
    onRewardTapped: @escaping () -> Void,
    showCollectedRewardButtonTapped: @escaping () -> Void,
    getRewardButtonTapped: @escaping () -> Void
  ) {
    self.completedMissionCount = completedMissionCount
    self.totalMissionCount = totalMissionCount
    self.onRewardTapped = onRewardTapped
    self.showCollectedRewardButtonTapped = showCollectedRewardButtonTapped
    self.getRewardButtonTapped = getRewardButtonTapped
  }
  
  static func == (lhs: MissionProgressView, rhs: MissionProgressView) -> Bool {
    lhs.completedMissionCount == rhs.completedMissionCount &&
    lhs.totalMissionCount == rhs.totalMissionCount
  }
  
  private var steps: [Milestone] {
    var result: [Milestone] = [.init(level: 0, title: "시작")]
    for i in 1..<totalMissionCount {
      result.append(.init(level: i, title: "\(i)개"))
    }
    result.append(.init(level: totalMissionCount, title: "Goal"))
    return result
  }
  private var isAllMissionCompleted: Bool {
    completedMissionCount >= totalMissionCount
  }
  private var currentStepIndex: Int {
    min(completedMissionCount, steps.count - 1)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      headerSection
      MilestoneProgressView(
        totalSteps: totalMissionCount,
        currentLevel: completedMissionCount,
        milestones: steps
      )
      
      if isAllMissionCompleted {
        HStack(spacing: 8) {
          CTAButton(
            size: .large,
            style: .secondary,
            title: "모은 리워드보기",
            action: showCollectedRewardButtonTapped
          )
          
          CTAButton(
            size: .large,
            style: .primary,
            title: "리워드 받기",
            action: getRewardButtonTapped
          )
        }
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
    .background(ColorResource.Neutral._800.color)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
  
  // MARK: - Header Section
  private var headerSection: some View {
    HStack(alignment: .top, spacing: 0) {
      HStack(alignment: .top, spacing: 12) {
        Circle()
          .frame(width: 36, height: 36)
          .foregroundStyle(ColorResource.Neutral._500.color)
          .overlay {
            ImageResource.fireworks.image
          }
        
        VStack(alignment: .leading, spacing: 4) {
          Text("오늘의 미션")
            .textStyle(.h5)
            .foregroundStyle(ColorResource.Text.main.color)
          
          Text("단 \(totalMissionCount)개만 도전해 보세요")
            .textStyle(.body5)
            .foregroundStyle(ColorResource.Text.Body.primary.color)
        }
      }
      
      Spacer()
      
      BadgeImageView(
        text: "리워드",
        textColor: ColorResource.Text.Body.primary.color,
        font: Typography.Body.body6,
        rightImage: ImageResource.Chevron.right.image
      )
      .onTapGesture {
        onRewardTapped()
      }
    }
  }
}

// MARK: - TodayMissionTimerView
struct TodayMissionTimerView: View, Equatable {
  let remainingSeconds: Int
  
  static func == (lhs: TodayMissionTimerView, rhs: TodayMissionTimerView) -> Bool {
    lhs.remainingSeconds == rhs.remainingSeconds
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("오늘 미션 종료까지")
        .textStyle(.body4)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
        .opacity(0.4)
      
      Text("\(remainingSeconds.formattedTime) 남음")
        .textStyle(.h2_1)
        .foregroundStyle(remainingSeconds <= 14400 ? ColorResource.Red._100.color : ColorResource.Text.main.color)
    }
    .frame(alignment: .center)
    .monospacedDigit()
  }
}

extension Int {
  fileprivate var formattedTime: String {
    let hours = self / 3600
    let minutes = (self % 3600) / 60
    let seconds = self % 60
    return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
  }
}
