//
//  ToastView.swift
//  Flifin
//
//  Created by 김유빈 on 7/1/25.
//

import SwiftUI

struct ToastView: View {
  private let type: ToastType
  private let backgroundColor: Color
  private let cornerRadius: CGFloat
  private let textStyle: Typography.TypographyStyle
  private let textColor: Color

  init(
    type: ToastType,
    backgroundColor: Color,
    cornerRadius: CGFloat,
    textStyle: Typography.TypographyStyle,
    textColor: Color
  ) {
    self.type = type
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.textStyle = textStyle
    self.textColor = textColor
  }

  var body: some View {
    HStack(spacing: 8) {
      image
        .padding(.vertical, 5)

      text
        .textStyle(textStyle)
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background {
      RoundedRectangle(cornerRadius: cornerRadius)
        .foregroundStyle(backgroundColor)
    }
  }
  
  @ViewBuilder
  var image: some View {
    switch type {
    case .textWithCheck:
      CheckMark(size: .small, style: .active)
    case .imageAndText(let image, _):
      image
        .resizable()
        .frame(width: 20, height: 20)
    }
  }
  
  var text: some View {
    switch type {
    case .textWithCheck(let text), .imageAndText(_, let text):
      Text(text)
    }
  }
}
