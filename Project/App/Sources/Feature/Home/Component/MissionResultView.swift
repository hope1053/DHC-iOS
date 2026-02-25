//
//  MissionResultView.swift
//  Flifin
//
//  Created by 김유빈 on 7/4/25.
//

import SwiftUI

struct MissionResultView: View {
  let type: MissionResult
  let onFirstButtonTapped: () -> Void
  let onSecondButtonTapped: () -> Void
  let onCloseButtonTapped: () -> Void

  var body: some View {
    VStack(spacing: 12) {
      closeButton

      content

      switch type {
      case .todaySuccess, .yesterDaySuccess:
        image
      default:
        EmptyView()
      }

      button
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(ColorResource.Neutral._700.color)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(ColorResource.Neutral._600.color)
    }
  }
  
  var closeButton: some View {
    Button {
      onCloseButtonTapped()
    } label: {
      Image(ImageResource.Icon.cancel)
        .resizable()
        .frame(width: 28, height: 28)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 12)
    }
  }
  
  var content: some View {
    VStack(spacing: 0) {
      DHCBadge(
        badgeTitle: type.badgeTitle,
        badgeStyle: .today,
        isActive: true
      )
      .padding(.bottom, 16)

      // Title
      Text(type.styleAppliedTitle)
        .textStyle(.h4)
        .multilineTextAlignment(.center)

      // Description
      if let description = type.description {
        Text(description)
          .textStyle(.body5)
          .foregroundStyle(ColorResource.Neutral._300.color)
          .multilineTextAlignment(.center)
          .padding(.top, 8 )
      }
    }
  }
  
  var image: some View {
    ImageResource.fireworks.image
      .resizable()
      .frame(width: 132, height: 132)
  }
  
  var button: some View {
    VStack(spacing: 4) {
      switch type {
      case .todaySuccess, .yesterDaySuccess:
        CTAButton(
          size: .large,
          style: .primary,
          title: "모은 리워드 보기",
          action: onFirstButtonTapped
        )
        
        CTAButton(
          size: .large,
          style: .tertiary,
          title: "닫기",
          action: onSecondButtonTapped
        )
        
      default:
        CTAButton(
          size: .large,
          style: .primary,
          title: "확인",
          action: onFirstButtonTapped
        )
      }
    }
    .padding(.horizontal, 20)
  }
}
