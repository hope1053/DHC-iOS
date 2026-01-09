//
//  ElementBalanceView.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import SwiftUI

import SDWebImageSwiftUI

struct ElementBalanceView: View {
  let elementBalance: RewardFortuneDetail.ElementBalance
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 8) {
        Text("내년 내 사주 오행의 균형")
          .textStyle(.h4_1)
          .foregroundStyle(ColorResource.Text.main.color)
        
        // TODO: 특정 키워드 색상 변경 필요
        Text(elementBalance.description.description)
          .textStyle(.body3)
          .foregroundStyle(ColorResource.Neutral._300.color)
          .multilineTextAlignment(.center)
      }
      .padding(.top, 40)
      .padding(.bottom, 16)
      
      chart
    }
    .padding(.horizontal, 20)
  }
  
  var chart: some View {
    VStack(spacing: 16) {
      HStack(alignment: .bottom, spacing: 32) {
        ForEach(elementBalance.balanceItem) { item in
          chartItem(item: item)
        }
      }
      .frame(maxWidth: .infinity)
    }
  }
  
  func chartItem(item: RewardFortuneDetail.ElementBalance.ElementBalanceItem) -> some View {
    VStack(spacing: 2) {
      VStack(spacing: 12) {
        Text("\(Int(item.percentage * 100))%")
          .textStyle(.h8)
          .foregroundStyle(ColorResource.Text.Body.primary.color)
        
        ZStack(alignment: .bottom) {
          RoundedRectangle(cornerRadius: 10)
            .fill(item.color)
            .frame(width: 10, height: CGFloat(item.percentage) * 80)
          
          RoundedRectangle(cornerRadius: 10)
            .fill(ColorResource.Background.glassEffect.color)
            .frame(width: 10, height: 80)
        }
        
        WebImage(url: item.imageURL) { image in
          image.resizable()
        }
        placeholder: {
          Rectangle()
            .fill(ColorResource.Neutral._600.color)
        }
        .frame(width: 24, height: 24)
      }
      
      Text(item.element)
        .textStyle(.body4)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
    }
  }
}
