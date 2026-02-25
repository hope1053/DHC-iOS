//
//  RewardCardView.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import SwiftUI

import SDWebImageSwiftUI

struct RewardCardView: View {
  private let reward: RewardItem
  
  init(reward: RewardItem) {
    self.reward = reward
  }
  
  var body: some View {
    VStack(spacing: 7) {
      iconView
        .padding(.horizontal, 4)
      
      Text(reward.title)
        .textStyle(.body6)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
        .multilineTextAlignment(.center)
    }
  }
  
  private var iconView: some View {
    WebImage(
      url: reward.iconURL,
      context: RemoteImageContext.context(for: reward.iconURL)
    ) { image in
      image
    }
    placeholder: {
      Rectangle()
        .fill(ColorResource.Neutral._600.color)
    }
    .resizable()
    .frame(width: 28, height: 28)
    .padding(12)
    .background(ColorResource.Background.glassEffect.color)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}
