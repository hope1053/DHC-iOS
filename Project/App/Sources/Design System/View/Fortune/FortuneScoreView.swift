//
//  FortuneScoreView.swift
//  Flifin
//
//  Created by 최혜린 on 6/18/25.
//

import SwiftUI

struct FortuneScoreView: View {
  private let title: String?
  private let score: String
  private let summary: String
  private let gradientType: LinearGradient.LinearType
  
  init(
    title: String?,
    score: String,
    summary: String,
    gradientType: LinearGradient.LinearType
  ) {
    self.title = title
    self.score = score
    self.summary = summary
    self.gradientType = gradientType
  }
  
  var body: some View {
    VStack(spacing: 12) {
      if let title {
        BadgeView(
          text: title,
          textColor: ColorResource.Text.Body.primary.color,
          font: Typography.Body.body6
        )
      }
      
      Text(score)
        .textStyle(.h0)
        .foregroundStyle(LinearGradient(gradientType))
      
      Text(summary)
        .textStyle(.body3)
        .foregroundStyle(ColorResource.Neutral._300.color)
        .multilineTextAlignment(.center)
    }
  }
}
