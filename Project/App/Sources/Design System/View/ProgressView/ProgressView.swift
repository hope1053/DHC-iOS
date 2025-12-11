//
//  ProgressView.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

struct ProgressView: View {
  private let totalCount: Int
  private let completedSteps: Int
  private let progressTitles: [String]
  
  private var totalStepCount: Int {
    totalCount + 1
  }
  private var currentStepIndex: Int {
    min(completedSteps, totalStepCount)
  }
  
  init(
    totalCount: Int,
    completedSteps: Int,
    progressTitles: [String]
  ) {
    self.totalCount = totalCount
    self.completedSteps = completedSteps
    self.progressTitles = progressTitles
  }
  
  var body: some View {
    VStack(spacing: 8) {
      progressBar
      progressLabels
    }
  }
  
  private var progressBar: some View {
    GeometryReader { geometry in
      let totalWidth = geometry.size.width
      let stepWidth = totalWidth / CGFloat(totalCount)
      let filledWidth = stepWidth * CGFloat(currentStepIndex)
      
      ZStack(alignment: .leading) {
        // Background track
        Capsule()
          .fill(ColorResource.Background.badgePrimary.color)
          .frame(height: 12)
        
        // Filled track
        Capsule()
          .fill(ColorResource.Text.Highlights.primary.color)
          .frame(width: max(28, filledWidth), height: 12)
        
        // Step dots
        HStack(spacing: 0) {
          ForEach(0..<totalStepCount, id: \.self) { index in
            if index == currentStepIndex {
              Spacer()
            } else {
              Circle()
                .fill(ColorResource.Text.Highlights.primary.color)
                .frame(width: 6, height: 6)
              
              if index < totalCount {
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
      ForEach(0..<totalStepCount, id: \.self) { index in
        if let title = progressTitles[safe: index] {
          if index == currentStepIndex {
            Text(title)
              .textStyle(.h7)
              .foregroundStyle(ColorResource.Text.Highlights.primary.color)
          } else if index == totalCount {
            Text(title)
              .textStyle(.h7)
              .foregroundStyle(ColorResource.Text.main.color)
          } else {
            Text(title)
              .textStyle(.h7)
              .foregroundStyle(ColorResource.Neutral._500.color)
          }

          if index < totalCount {
            Spacer()
          }
        }
      }
    }
  }
}
