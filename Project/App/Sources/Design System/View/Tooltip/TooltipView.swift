//
//  TooltipView.swift
//  Flifin
//
//  Created by hyerin on 6/20/25.
//

import SwiftUI

enum Tooltip {
  case onboardingGradient
  case rewardGradient
  case solid
  
  var backgroundColor: AnyShapeStyle {
    switch self {
    case .onboardingGradient:
      return AnyShapeStyle(LinearGradient(.tooltip01))
    case .rewardGradient:
      return AnyShapeStyle(LinearGradient(.fortuneBorderLow).opacity(0.28))
    case .solid:
      return AnyShapeStyle(ColorResource.Neutral._500.color)
    }
  }
  
  var foregroundColor: Color {
    switch self {
    case .onboardingGradient, .solid:
      ColorResource.Background.main.color
    case .rewardGradient:
      ColorResource.Text.Highlights.primary.color
    }
  }
  
  var bottomArrowBackgroundColor: AnyShapeStyle {
    switch self {
    case .onboardingGradient:
      return AnyShapeStyle(
        LinearGradient(
          .tooltip01,
          startPoint: .bottom,
          endPoint: .top
        )
      )
    case .rewardGradient:
      return AnyShapeStyle(
        LinearGradient(
          .fortuneBorderLow,
          startPoint: .bottom,
          endPoint: .top
        )
        .opacity(0.28)
      )
    case .solid:
      return AnyShapeStyle(ColorResource.Neutral._500.color)
    }
  }
  
  var typography: Typography.TypographyStyle {
    switch self {
    case .onboardingGradient:
      return Typography.Head.h7
    case .rewardGradient:
      return Typography.Body.body5
    case .solid:
      return Typography.Body.body5
    }
  }
}

struct TooltipView: View {
  private let type: Tooltip
  private let message: String
  private let expandWidth: Bool
  
  init(
    type: Tooltip,
    message: String,
    expandWidth: Bool = false
  ) {
    self.type = type
    self.message = message
    self.expandWidth = expandWidth
  }
  
  var body: some View {
    VStack(spacing: 0) {
      contentView
      bottomArrowView
    }
  }
  
  private var contentView: some View {
    textView
      .padding(10)
      .background {
        switch type {
        case .rewardGradient:
          ChromeMaterialBlurView(style: .systemUltraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        default:
          RoundedRectangle(cornerRadius: 8)
            .fill(type.backgroundColor)
        }
      }
  }
  
  private var textView: some View {
    Text(message)
      .textStyle(type.typography)
      .foregroundStyle(type.foregroundColor)
      .lineLimit(nil)
      .fixedSize(horizontal: false, vertical: true)
      .if(expandWidth) { view in
        view.frame(maxWidth: .infinity)
      }
      .padding(.horizontal, 2)
      .multilineTextAlignment(.center)
  }
  
  private var bottomArrowView: some View {
    Group {
      switch type {
      case .rewardGradient:
        ChromeMaterialBlurView(style: .systemUltraThinMaterial)
          .mask(BottomRoundedInvertedTriangle(cornerRadius: 1))
      default:
        BottomRoundedInvertedTriangle(cornerRadius: 1)
          .fill(type.bottomArrowBackgroundColor)
      }
    }
    .frame(width: 12, height: 6)
  }
}
