//
//  BadgeImageView.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import SwiftUI

struct BadgeImageView: View {
  private let text: String
  private let textColor: Color
  private let font: Typography.TypographyStyle
  private let backgroundColor: Color
  private let rightImage: Image
  
  init(
    text: String,
    textColor: Color,
    font: Typography.TypographyStyle,
    backgroundColor: Color = ColorResource.Background.glassEffect.color,
    rightImage: Image
  ) {
    self.text = text
    self.textColor = textColor
    self.font = font
    self.backgroundColor = backgroundColor
    self.rightImage = rightImage
  }
  
  var body: some View {
    HStack(spacing: 2) {
      Text(text)
        .textStyle(font)
        .foregroundStyle(textColor)
      
      rightImage
        .resizable()
        .frame(width: 16, height: 16)
    }
    .padding(.vertical, 2)
    .padding(.leading, 12)
    .padding(.trailing, 4)
    .background(backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: .infinity))
  }
}
