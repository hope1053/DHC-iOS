//
//  TodayMissionView.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import SwiftUI

struct TodayMissionView: View {
  let remainingSeconds: Int
  let completedMissionCount: Int
  let didTapRewardButton: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      TodayMissionTimerView(remainingSeconds: remainingSeconds)
      
      MissionProgressView(
        completedMissionCount: completedMissionCount,
        totalMissionCount: 3,
        onRewardTapped: {
          didTapRewardButton()
        }
      )
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
    .padding(.bottom, 40)
  }
}

// MARK: - MissionProgressView
struct MissionProgressView: View {
  let completedMissionCount: Int
  let totalMissionCount: Int
  let onRewardTapped: () -> Void
  
  private var steps: [String] {
    var result = ["시작"]
    for i in 1..<totalMissionCount {
      result.append("\(i)개")
    }
    result.append("Goal")
    return result
  }
  
  private var currentStepIndex: Int {
    min(completedMissionCount, steps.count - 1)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      headerSection
      ProgressView(
        totalCount: totalMissionCount,
        completedSteps: completedMissionCount,
        progressTitles: steps
      )
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
struct TodayMissionTimerView: View {
  let remainingSeconds: Int
  
  var body: some View {
    VStack(spacing: 0) {
      Text("오늘 미션 종료까지")
        .textStyle(.body4)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
        .opacity(0.4)
      
      Text("\(remainingSeconds.formattedTime) 남음")
        .textStyle(.h2_1)
        .foregroundStyle(ColorResource.Text.main.color)
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
