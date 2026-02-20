//
//  ReceivedRewardView.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import SwiftUI

struct ReceivedRewardView: View {
  private let rewards: [RewardItem]
  private let onRewardItemTapped: (ReceivedRewardAction) -> Void
  
  init(
    rewards: [RewardItem] = [],
    onRewardItemTapped: @escaping (ReceivedRewardAction) -> Void
  ) {
    self.rewards = rewards
    self.onRewardItemTapped = onRewardItemTapped
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("받은 리워드들")
        .textStyle(.body5)
        .foregroundStyle(ColorResource.Neutral._300.color)
      
      if rewards.isEmpty {
        emptyStateView
      } else {
        rewardCollectionView
      }
    }
    .padding(20)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
  private var emptyStateView: some View {
    Text("아직 받은 리워드가 없습니다")
      .textStyle(.body6)
      .foregroundStyle(ColorResource.Neutral._400.color)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.vertical, 20)
  }
  
  private var rewardCollectionView: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4),
      spacing: 20,
      content: {
        ForEach(rewards) { reward in
          RewardCardView(reward: reward)
            .onTapGesture {
              if let message = reward.message {
                // message가 있으면 토스트 표시
                onRewardItemTapped(.showToast(message))
              } else {
                // message가 없으면 상세 화면으로 이동
                onRewardItemTapped(.moveToDetailView(
                  type: reward.type,
                  isUsed: reward.isUsed
                ))
              }
            }
        }
      }
    )
  }
}
