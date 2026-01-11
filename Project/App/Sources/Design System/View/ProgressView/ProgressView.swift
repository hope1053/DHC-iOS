//
//  ProgressView.swift
//  Flifin
//
//  Created by hyerin on 12/16/25.
//

import SwiftUI

// MARK: - MilestoneType
enum MilestoneType {
  case dot
  case image(Image)
}

// MARK: - Milestone
struct Milestone {
  let level: Int
  let title: String
  let type: MilestoneType
  
  init(
    level: Int,
    title: String,
    type: MilestoneType = .dot
  ) {
    self.level = level
    self.title = title
    self.type = type
  }
}

// MARK: - MilestoneProgressView
struct MilestoneProgressView: View {
  private let totalSteps: Int
  private let currentLevel: Int
  private let milestones: [Milestone]
  
  init(
    totalSteps: Int,
    currentLevel: Int,
    milestones: [Milestone]
  ) {
    self.totalSteps = totalSteps
    self.currentLevel = currentLevel
    self.milestones = milestones
  }
  
  // 진행도 계산 (0.0 ~ 1.0)
  private func calculateProgress() -> Double {
    guard milestones.count >= 2 else { return 0.0 }
    
    // currentLevel이 어느 구간에 속하는지 찾기
    for i in 0..<(milestones.count - 1) {
      let startMilestone = milestones[i]
      let endMilestone = milestones[i + 1]
      
      if currentLevel >= startMilestone.level && currentLevel <= endMilestone.level {
        // 구간을 찾음
        let segmentIndex = Double(i)
        let numberOfSegments = Double(milestones.count - 1)
        let segmentStartProgress = segmentIndex / numberOfSegments
        let segmentSize = 1.0 / numberOfSegments
        
        // 구간 내 상대 위치 계산
        let levelRange = endMilestone.level - startMilestone.level
        let progressInSegment = levelRange > 0
          ? Double(currentLevel - startMilestone.level) / Double(levelRange)
          : 0.0
        
        return segmentStartProgress + (progressInSegment * segmentSize)
      }
    }
    
    // currentLevel이 범위를 벗어난 경우 처리
    if currentLevel < milestones.first!.level {
      return 0.0
    } else if currentLevel > milestones.last!.level {
      return 1.0
    }
    
    return 0.0
  }
  
  var body: some View {
    VStack(spacing: 12) {
      progressBar
      progressLabels
    }
  }
  
  private var progressBar: some View {
    GeometryReader { geometry in
      let totalWidth = geometry.size.width
      let progress = calculateProgress()
      let filledWidth = totalWidth * CGFloat(progress)
      
      ZStack(alignment: .leading) {
        // Background track
        Capsule()
          .fill(ColorResource.Background.badgePrimary.color)
          .frame(height: 12)
        
        // Filled track
        Capsule()
          .fill(ColorResource.Text.Highlights.primary.color)
          .frame(width: max(28, filledWidth), height: 12)
        
        // Milestone markers (항상 4개, 균등 배치)
        HStack(spacing: 0) {
          ForEach(Array(milestones.enumerated()), id: \.offset) { index, milestone in
            if milestone.level == currentLevel {
              Spacer()
            } else {
              milestoneMarker(for: milestone.type)
              
              if index < milestones.count - 1 {
                Spacer()
              }
            }
          }
        }
        .padding(.horizontal, 16)
      }
    }
    .frame(height: 12)
  }
  
  private var progressLabels: some View {
    HStack(spacing: 0) {
      ForEach(Array(milestones.enumerated()), id: \.offset) { index, milestone in
        Text(milestone.title)
          .textStyle(.h7)
          .foregroundStyle(labelColor(for: milestone, index: index))
        
        if index < milestones.count - 1 {
          Spacer()
        }
      }
    }
  }
  
  // 라벨 색상 결정
  private func labelColor(for milestone: Milestone, index: Int) -> Color {
    return currentLevel == milestone.level
      ? ColorResource.Text.Highlights.primary.color
      : ColorResource.Neutral._500.color
  }
  
  // Milestone 마커 생성
  @ViewBuilder
  private func milestoneMarker(for type: MilestoneType) -> some View {
    switch type {
    case .dot:
      Circle()
        .fill(ColorResource.Text.Highlights.primary.color)
        .frame(width: 6, height: 6)
      
    case .image(let image):
      image
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
    }
  }
}
