//
//  TodayMissionDoneDTO.swift
//  Flifin
//
//  Created by hyerin on 7/15/25.
//

import Foundation

struct TodayMissionDoneDTO: Decodable {
  let todaySavedMoney: String
  let isTodayMissionSuccess: Bool
  let earnedPoint: Int
  
  enum CodingKeys: String, CodingKey {
    case todaySavedMoney
    case isTodayMissionSuccess = "missionSuccess"
    case earnedPoint
  }
}

extension TodayMissionDoneDTO {
  var toDomain: TodayMissionStatus {
    .init(
      isMissionSuccess: isTodayMissionSuccess,
      earnedPoint: earnedPoint
    )
  }
}
