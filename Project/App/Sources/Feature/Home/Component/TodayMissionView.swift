//
//  TodayMissionView.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import SwiftUI

enum TodayMissionState: Equatable {
  case able
  case disable
}

struct TodayMissionView: View, Equatable {
  private let remainingSeconds: Int
  private let completedMissionCount: Int
  private let missionResult: MissionResult?
  private let state: TodayMissionState
  private let didTapRewardButton: () -> Void
  
  init(
    remainingSeconds: Int,
    completedMissionCount: Int,
    missionResult: MissionResult? = nil,
    state: TodayMissionState = .able,
    didTapRewardButton: @escaping () -> Void
  ) {
    self.remainingSeconds = remainingSeconds
    self.completedMissionCount = completedMissionCount
    self.missionResult = missionResult
    self.state = state
    self.didTapRewardButton = didTapRewardButton
  }
  
  static func == (lhs: TodayMissionView, rhs: TodayMissionView) -> Bool {
    lhs.remainingSeconds == rhs.remainingSeconds &&
    lhs.completedMissionCount == rhs.completedMissionCount &&
    lhs.missionResult == rhs.missionResult &&
    lhs.state == rhs.state
  }
  
  var body: some View {
    VStack(spacing: 24) {
      TodayMissionTimerView(remainingSeconds: remainingSeconds)
        .equatable()
      
      MissionProgressView(
        completedMissionCount: completedMissionCount,
        totalMissionCount: 3,
        missionResult: missionResult,
        state: state,
        onRewardTapped: didTapRewardButton
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
  private let missionResult: MissionResult?
  private let state: TodayMissionState
  private let onRewardTapped: () -> Void
  
  init(
    completedMissionCount: Int,
    totalMissionCount: Int,
    missionResult: MissionResult? = nil,
    state: TodayMissionState = .able,
    onRewardTapped: @escaping () -> Void
  ) {
    self.completedMissionCount = completedMissionCount
    self.totalMissionCount = totalMissionCount
    self.missionResult = missionResult
    self.state = state
    self.onRewardTapped = onRewardTapped
  }
  
  static func == (lhs: MissionProgressView, rhs: MissionProgressView) -> Bool {
    lhs.completedMissionCount == rhs.completedMissionCount &&
    lhs.totalMissionCount == rhs.totalMissionCount &&
    lhs.missionResult == rhs.missionResult &&
    lhs.state == rhs.state
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
  
  private var headerTitle: String {
    guard let missionResult else {
      return "오늘의 미션"
    }
    
    switch missionResult {
    case .todayFail:
      return "아쉽게 실패했어요"
    case .yesterDayFail:
      return "리워드 2배 이벤트"
    case .fewDaysFail:
      return "웰컴백 이벤트"
    case .todaySuccess, .yesterDaySuccess:
      return "오늘의 미션"
    }
  }
  
  private var headerDescription: String {
    if state == .disable {
      return "받은 리워드를 확인해보세요!"
    }
    
    let completedMissionDescription = {
      switch completedMissionCount {
      case 0:
        return "단 \(totalMissionCount)개만 도전해 보세요"
      case 1:
        return "벌써 한개나 성공했네요!"
      case 2:
        return "리워드까지 한 걸음 남았어요!"
      case 3:
        return "리워드를 받아보세요!"
      default:
        return "리워드를 받아보세요!"
      }
    }() 
    
    guard let missionResult else {
      return completedMissionDescription
    }
    
    switch missionResult {
    case .todayFail:
      return """
      하지만 내일 미션을 성공하면
      리워드가 두배에요!
      """
    case .yesterDayFail:
      return "오늘은 리워드 보상이 2배에요!"
    case .fewDaysFail:
      return "오늘은 리워드 보상이 4배에요!"
    case .todaySuccess, .yesterDaySuccess:
      return completedMissionDescription
    }
  }
  
  var body: some View {
    VStack(spacing: 16) {
      headerSection
      MilestoneProgressView(
        totalSteps: totalMissionCount,
        currentLevel: completedMissionCount,
        milestones: steps,
        style: progressStyle
      )
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
    .background(backgroundColor)
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
              .resizable()
              .frame(width: 24, height: 24)
          }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(headerTitle)
            .textStyle(.h5)
            .foregroundStyle(titleColor)
          
          Text(headerDescription)
            .textStyle(.body5)
            .foregroundStyle(descriptionColor)
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

  private var progressStyle: MilestoneProgressView.Style {
    switch state {
    case .able:
      return .default
    case .disable:
      return .init(
        trackColor: ColorResource.Neutral._600.color,
        fillColor: ColorResource.Neutral._500.color,
        markerColor: ColorResource.Neutral._400.color,
        highlightedLabelColor: ColorResource.Neutral._500.color,
        normalLabelColor: ColorResource.Neutral._500.color
      )
    }
  }
  
  private var titleColor: Color {
    state == .able ? ColorResource.Text.main.color : ColorResource.Neutral._400.color
  }
  
  private var descriptionColor: Color {
    state == .able ? ColorResource.Text.Body.primary.color : ColorResource.Neutral._400.color
  }
  
  private var backgroundColor: Color {
    state == .able ? ColorResource.Neutral._800.color : ColorResource.Neutral._700.color
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
