//
//  FortuneTestListRowView.swift
//  Flifin
//
//  Created by hyerin on 1/13/26.
//

import SwiftUI

import SDWebImageSwiftUI

struct FortuneTestListRowView: View {
  private let imageURL: URL?
  private let title: String
  private let action: (() -> Void)?

  init(
    imageURL: URL?,
    title: String,
    action: (() -> Void)?
  ) {
    self.imageURL = imageURL
    self.title = title
    self.action = action
  }

  var body: some View {
    if let action {
      Button(action: action) {
        content
      }
    } else {
      content
    }
  }

  var content: some View {
    HStack {
      WebImage(url: imageURL) { image in
        image.resizable()
      } placeholder: {
        Rectangle()
          .fill(ColorResource.Neutral._600.color)
      }
      .frame(width: 20, height: 20)

      Text(title)
        .textStyle(.body3)
        .foregroundStyle(ColorResource.Text.main.color)
      
      Spacer()
      
      ImageResource.Chevron.right.image
        .resizable()
        .frame(width: 20, height: 20)
    }
    .padding(.horizontal, 16)
    .frame(height: 64)
    .background(ColorResource.Neutral._700.color)
    .cornerRadius(12)
  }
}
