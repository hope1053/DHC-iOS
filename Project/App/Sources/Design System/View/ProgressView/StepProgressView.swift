//
//  StepProgressView.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import SwiftUI

// MARK: - StepProgressView
struct StepProgressView: View {
  private let milestones: [Milestone]
  private let currentLevel: Int
  
  init(
    milestones: [Milestone],
    currentLevel: Int
  ) {
    self.milestones = milestones
    self.currentLevel = currentLevel
  }
  
  private func calculateProgress() -> Double {
    guard milestones.count >= 2 else { return 0.0 }
    
    let firstLevel = milestones.first!.level
    let lastLevel = milestones.last!.level
    let totalRange = lastLevel - firstLevel
    
    guard totalRange > 0 else { return 0.0 }
    
    let clampedLevel = max(firstLevel, min(currentLevel, lastLevel))
    return Double(clampedLevel - firstLevel) / Double(totalRange)
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
        Capsule()
          .fill(ColorResource.Background.badgePrimary.color)
          .frame(height: 12)
        
        Capsule()
          .fill(ColorResource.Text.Highlights.primary.color)
          .frame(width: max(28, filledWidth), height: 12)
        
        HStack(spacing: 0) {
          ForEach(Array(milestones.enumerated()), id: \.offset) { index, milestone in
            milestoneMarker(for: milestone.type)
              .frame(maxWidth: .infinity, alignment: .center)
            
            if index < milestones.count - 1 {
              Spacer(minLength: 0)
            }
          }
        }
      }
    }
    .frame(height: 12)
  }
  
  private var progressLabels: some View {
    HStack(spacing: 0) {
      ForEach(Array(milestones.enumerated()), id: \.offset) { index, milestone in
        Text(milestone.title)
          .textStyle(.h7)
          .foregroundStyle(labelColor(for: milestone))
          .frame(maxWidth: .infinity, alignment: .center)
        
        if index < milestones.count - 1 {
          Spacer(minLength: 0)
        }
      }
    }
  }
  
  private func labelColor(for milestone: Milestone) -> Color {
    return currentLevel == milestone.level
      ? ColorResource.Text.Highlights.primary.color
      : ColorResource.Neutral._500.color
  }
  
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

