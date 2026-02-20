//
//  YearlyFortuneDTO.swift
//  Flifin
//
//  Created by hyerin on 2/5/26.
//

import Foundation

// MARK: - YearlyFortuneDTO
struct YearlyFortuneDTO: Decodable {
  let year: Int
  let generatedDate: String
  let totalScore: Int
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
      let status: String
    }
  }
}

extension YearlyFortuneDTO {
//  var toDomain: YearlyFortune {
//    .init(
//      title: <#T##String#>,
//      scoreInfo: <#T##YearlyFortune.FortuneScore#>,
//      cardInfo: <#T##YearlyFortune.FortuneCard#>,
//      overallFortune: <#T##YearlyFortune.OverallFortune#>,
//      categoryFortuneItems: <#T##[YearlyFortune.CategoryFortuneItem]#>,
//      elementBalance: <#T##YearlyFortune.ElementBalance#>,
//      elementShift: <#T##YearlyFortune.ElementShift#>,
//      tipInfos: <#T##[YearlyFortune.Tip]#>
//    )
//  }
}
