//
//  TooltipView.swift
//  Flifin
//
//  Created by hyerin on 6/20/25.
//

import SwiftUI

enum Tooltip {
  case gradient
  case solid
  
  var backgroundColor: AnyShapeStyle {
    switch self {
    case .gradient:
      return AnyShapeStyle(LinearGradient(.tooltip01))
    case .solid:
      return AnyShapeStyle(ColorResource.Neutral._500.color)
    }
  }
  
  var bottomArrowBackgroundColor: AnyShapeStyle {
    switch self {
    case .gradient:
      return AnyShapeStyle(
        LinearGradient(
          .tooltip01,
          startPoint: .bottom,
          endPoint: .top
        )
      )
    case .solid:
      return AnyShapeStyle(ColorResource.Neutral._500.color)
    }
  }
  
  var typography: Typography.TypographyStyle {
    switch self {
    case .gradient:
      return Typography.Head.h7
    case .solid:
      return Typography.Body.body5
    }
  }
}

struct TooltipView: View {
  private let type: Tooltip
  private let message: String
  
  init(
    type: Tooltip,
    message: String
  ) {
    self.type = type
    self.message = message
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
      .background(type.backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
  
  private var textView: some View {
    Text(message)
      .textStyle(type.typography)
      .foregroundStyle(ColorResource.Background.main.color)
      .padding(.horizontal, 2)
  }
  
  private var bottomArrowView: some View {
    BottomRoundedInvertedTriangle(cornerRadius: 1)
      .fill(
        LinearGradient(
          .tooltip01,
          startPoint: .bottom,
          endPoint: .top
        )
      )
      .frame(width: 12, height: 6)
  }
}
