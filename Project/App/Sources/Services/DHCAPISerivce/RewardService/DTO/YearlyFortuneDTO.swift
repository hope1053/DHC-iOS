//
//  YearlyFortuneDTO.swift
//  Flifin
//
//  Created by hyerin on 2/5/26.
//

import SwiftUI

// MARK: - YearlyFortuneDTO
struct YearlyFortuneDTO: Decodable {
  let year: Int
  let generatedDate: String
  let totalScore: Int
  let cardInfo: CardInfoDTO
  let summaryTitle: String
  let summaryDetail: String
  let fortuneOverview: FortuneOverviewDTO
  let fiveElements: FiveElementsDTO
  let yearlyEnergyTitle: String
  let yearlyEnergyDetail: String
  let tips: [TipDTO]
}

extension YearlyFortuneDTO {
  // MARK: - FortuneOverview
  struct FortuneOverviewDTO: Decodable {
    let money: FortuneOverviewItemDTO
    let love: FortuneOverviewItemDTO
    let study: FortuneOverviewItemDTO
    
    struct FortuneOverviewItemDTO: Decodable {
      let title, description: String
      let image: String
    }
  }

  // MARK: - FiveElements
  struct FiveElementsDTO: Decodable {
    let dominantElement: String
    let dominantWarning: String
    let wood: ElementItemDTO
    let fire: ElementItemDTO
    let earth: ElementItemDTO
    let metal: ElementItemDTO
    let water: ElementItemDTO
    
    struct ElementItemDTO: Decodable {
      let percentage: Int
      let status: ElementStatus
      
      enum ElementStatus: String, Decodable {
        case lack = "부족"
        case balanced = "적정"
        case high = "과다"
        
        var displayColor: Color {
          switch self {
          case .lack:
            return ColorResource.levelEasy.color
          case .balanced:
            return ColorResource.Green._100.color
          case .high:
            return ColorResource.Red._100.color
          }
        }
      }
    }
  }
}

extension YearlyFortuneDTO {
  var toDomain: YearlyFortune {
    return .init(
      navigationTitle: "1년 운세",
      scoreInfo: .init(
        badgeTitle: "\(year)년 운세 총평",
        scoreString: "\(totalScore)점",
        score: totalScore,
        // TODO: summary 현재 API에 없어서 추가 필요
        summary: """
        올 한해는 전반적으로 마음이 들뜨는 날이에요, 
        한템포 쉬어가요.
        """
      ),
      cardInfo: cardInfo.toDomain,
      overallFortune: .init(
        title: summaryTitle,
        fortune: summaryDetail
      ),
      categoryFortuneItems: [
        .init(
          imageURL: URL(string: fortuneOverview.money.image),
          title: fortuneOverview.money.title,
          description: fortuneOverview.money.description
        ),
        .init(
          imageURL: URL(string: fortuneOverview.love.image),
          title: fortuneOverview.love.title,
          description: fortuneOverview.love.description
        ),
        .init(
          imageURL: URL(string: fortuneOverview.study.image),
          title: fortuneOverview.study.title,
          description: fortuneOverview.study.description
        )
      ],
      elementBalance: .init(
        description: .init(
          description: fiveElements.dominantWarning,
          highlight: fiveElements.dominantElement,
          color: ColorResource.Red._100.color
        ),
        balanceItem: [
          .init(
            element: "wood",
            elementStatus: fiveElements.wood.status.rawValue,
            percentage: fiveElements.wood.percentage.ratioValue,
            color: fiveElements.wood.status.displayColor,
            imageURL: .urlForResource(.tree)
          ),
          .init(
            element: "fire",
            elementStatus: fiveElements.fire.status.rawValue,
            percentage: fiveElements.fire.percentage.ratioValue,
            color: fiveElements.fire.status.displayColor,
            imageURL: .urlForResource(.fire)
          ),
          .init(
            element: "earth",
            elementStatus: fiveElements.earth.status.rawValue,
            percentage: fiveElements.earth.percentage.ratioValue,
            color: fiveElements.earth.status.displayColor,
            imageURL: .urlForResource(.soil)
          ),
          .init(
            element: "metal",
            elementStatus: fiveElements.metal.status.rawValue,
            percentage: fiveElements.metal.percentage.ratioValue,
            color: fiveElements.metal.status.displayColor,
            imageURL: .urlForResource(.gold)
          ),
          .init(
            element: "water",
            elementStatus: fiveElements.water.status.rawValue,
            percentage: fiveElements.water.percentage.ratioValue,
            color: fiveElements.water.status.displayColor,
            imageURL: .urlForResource(.water)
          )
        ]
      ),
      elementShift: .init(
        title: yearlyEnergyTitle,
        description: yearlyEnergyDetail
      ),
      tipInfos: tips.map { $0.toDomain }
    )
  }
}

private extension Int {
  var ratioValue: Double {
    Double(self) / 100.0
  }
}
