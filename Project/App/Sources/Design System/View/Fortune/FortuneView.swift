//
//  FortuneView.swift
//  Flifin
//
//  Created by 최혜린 on 6/18/25.
//

import SwiftUI

struct FortuneView<Card: View>: View {
  private let title: String?
  private let score: String
  private let summary: String
  private let gradientType: LinearGradient.LinearType
  private let cardView: Card
  
  init(
    title: String?,
    score: String,
    summary: String,
    gradientType: LinearGradient.LinearType,
    @ViewBuilder cardView: () -> Card
  ) {
    self.title = title
    self.score = score
    self.summary = summary
    self.gradientType = gradientType
    self.cardView = cardView()
  }
  
  var body: some View {
    VStack(spacing: 0) {
      FortuneScoreView(
        title: title,
        score: score,
        summary: summary,
        gradientType: gradientType
      )
      .padding(.bottom, 24)
      
      cardView
      .padding(.top, 40)
      .padding(.bottom, 12)
      
      ImageResource.fortuneCardShadow.image
        .resizable()
        .frame(height: 32)
    }
  }
}
