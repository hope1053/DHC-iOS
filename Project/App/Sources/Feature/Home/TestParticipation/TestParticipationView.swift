//
//  TestParticipationView.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import SwiftUI

import ComposableArchitecture
import SDWebImageSwiftUI

struct TestParticipationView: View {
  let store: StoreOf<TestParticipationReducer>
  
  var body: some View {
    VStack(spacing: 12) {
      closeButton
        .padding(.trailing, 12)
      
      contentSection
      
      CTAButton(
        size: .large,
        style: .primary,
        title: "테스트 참여하기",
        action: {
          store.send(.participateButtonTapped)
        }
      )
      .padding(.horizontal, 20)
    }
    .padding(.top, 16)
    .padding(.bottom, 20)
    .background(ColorResource.Neutral._800.color)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
  
  private var closeButton: some View {
    HStack {
      Spacer()
      
      Button(
        action: {
          store.send(.closeButtonTapped)
        },
        label: {
          Image(systemName: "xmark")
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(ColorResource.Neutral._300.color)
            .frame(width: 32, height: 32)
        }
      )
    }
  }
  
  private var contentSection: some View {
    VStack(spacing: 0) {
      WebImage(
        url: store.test.imageURL,
        context: RemoteImageContext.context(for: store.test.imageURL),
        content: { image in
          image.image?
            .resizable()
            .aspectRatio(contentMode: .fill)
        }
      )
      .clipped()
      .padding(.bottom, 16)
      
      Text(store.test.title)
        .textStyle(.h4_1)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
        .multilineTextAlignment(.center)
        .padding(.bottom, 4)
      
      Text(store.test.subTitle)
        .textStyle(.body5)
        .foregroundStyle(ColorResource.Neutral._300.color)
        .multilineTextAlignment(.center)
    }
  }
}
