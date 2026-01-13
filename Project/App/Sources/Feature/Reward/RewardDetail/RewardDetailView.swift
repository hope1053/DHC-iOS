//
//  RewardDetailView.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import SwiftUI

import ComposableArchitecture
import SDWebImageSwiftUI

struct RewardDetailView: View {
  let store: StoreOf<RewardDetailReducer>
  private let columns: [GridItem] = [GridItem(spacing: 12), GridItem()]
  
  init(store: StoreOf<RewardDetailReducer>) {
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 0) {
      DHCNavigationBar(
        type: .title(store.title),
        backButtonAction: {
          store.send(.backButtonTapped)
        }
      )
      
      if let scoreInfo = store.scoreInfo,
         let cardInfo = store.cardInfo,
         let overallFortune = store.overallFortune,
         let elementBalance = store.elementBalance,
         let elementShift = store.elementShift {
        ScrollView {
          VStack(spacing: 24) {
            FortuneView(
              title: scoreInfo.fortuneTitle,
              score: scoreInfo.scoreString,
              summary: scoreInfo.summary,
              gradientType: FortuneScore(score: scoreInfo.score).textGradient,
              cardView: {
                FortuneCardFrontView(
                  backgroundImageURL: cardInfo.backgroundImageURL,
                  title: cardInfo.title,
                  fortune: cardInfo.fortune
                )
              }
            )
            .padding(.top, 32)
            
            overallFortuneView(overallFortune: overallFortune)
            
            categoryFortuneView
            
            ElementBalanceView(elementBalance: elementBalance)
            
            elementReflectionView(elementShift: elementShift)
            
            tipInfoView
              .padding(.bottom, 53)
          }
        }
        .clipShape(Rectangle())
        .scrollIndicators(.hidden)
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .radialGradientBackground(
      type: .backgroundGradient02,
      endRadiusMultiplier: 1.2,
      scaleEffectX: 1.8
    )
    .background(ColorResource.Background.main.color)
    .onAppear {
      store.send(.onAppear)
    }
    .navigationBarBackButtonHidden()
  }
  
  func overallFortuneView(overallFortune: RewardFortuneDetail.OverallFortune) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("전반적인 운세")
        .textStyle(.h4_1)
        .foregroundStyle(ColorResource.Text.main.color)
      
      MessageCardView(
        title: overallFortune.title,
        message: overallFortune.fortune
      )
    }
    .padding(.horizontal, 20)
  }
  
  var categoryFortuneView: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("한 눈에 보는 운세")
        .textStyle(.h5_1)
        .foregroundStyle(ColorResource.Text.main.color)
      
      VStack(spacing: 12) {
        ForEach(store.categoryFortuneItems, id: \.title) { item in
          TipCardView(
            imageURL: item.imageURL,
            title: item.title,
            content: item.description,
            type: .medium
          )
        }
      }
    }
    .padding(.horizontal, 20)
  }
  
  func elementReflectionView(elementShift: RewardFortuneDetail.ElementShift) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("올해의 기운 변화")
        .textStyle(.h5_1)
        .foregroundStyle(ColorResource.Text.main.color)
      
      MessageCardView(
        title: elementShift.title,
        message: elementShift.description
      )
    }
    .padding(.horizontal, 20)
  }
  
  var tipInfoView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("이번년도 꿀팁")
        .textStyle(.h5_1)
        .foregroundStyle(ColorResource.Text.main.color)
      
      LazyVGrid(
        columns: columns,
        spacing: 12,
        content: {
          ForEach(store.tipInfos) { item in
            TipCardView(
              imageURL: item.imageURL,
              title: item.title,
              content: item.content,
              type: .small(item.contentColor)
            )
          }
        }
      )
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  RewardDetailView(
    store: Store(
      initialState: .init(type: .sample),
      reducer: RewardDetailReducer.init
    )
  )
}
