//
//  TipCardView.swift
//  Flifin
//
//  Created by hyerin on 6/20/25.
//

import SwiftUI

import SDWebImageSwiftUI

enum TipCardType: Equatable {
  case medium
  case small(Color?)
}

struct TipCardView: View {
  private let imageURL: URL?
  private let title: String
  private let content: String
  private let type: TipCardType
  
  init(
    imageURL: URL?,
    title: String,
    content: String,
    type: TipCardType
  ) {
    self.imageURL = imageURL
    self.title = title
    self.content = content
    self.type = type
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 4) {
        WebImage(
          url: imageURL,
          context: RemoteImageContext.context(for: imageURL),
          content: { image in
            image.resizable()
          },
          placeholder: {
            EmptyView()
          }
        )
        .frame(width: 20, height: 20)
        
        Text(title)
          .foregroundStyle(type == TipCardType.medium ? ColorResource.Neutral._200.color : ColorResource.Neutral._400.color)
          .textStyle(.body5)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(spacing: 8) {
        switch type {
        case .medium:
          Text(content)
            .foregroundStyle(ColorResource.Text.Body.primary.color)
            .textStyle(.body3)
          
        case .small(let contentColor):
          if let contentColor {
            DotView(color: contentColor, size: 8)
          }
          
          Text(content)
            .foregroundStyle(contentColor ?? ColorResource.Text.Body.primary.color)
            .textStyle(.h3)
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
