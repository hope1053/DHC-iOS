//
//  MissionResult.swift
//  Flifin
//
//  Created by hyerin on 1/14/26.
//

import SwiftUI

enum MissionResult: Equatable {
  case todaySuccess(earnedPoint: Int)
  case todayFail
  case yesterDaySuccess(earnedPoint: Int)
  case yesterDayFail
  case fewDaysFail
  
  init?(from pastMissionStatus: HomeInfo.PastMissionStatus?) {
    guard let pastMissionStatus else {
      return nil
    }
    
    switch pastMissionStatus {
    case .yesterDayMissionSuccess(let earnedPoint):
      self = .yesterDaySuccess(earnedPoint: earnedPoint)
    case .yesterDayMissionFail:
      self = .yesterDayFail
    case .longAbsence:
      self = .fewDaysFail
    }
  }
  
  var badgeTitle: String {
    switch self {
    case .todaySuccess, .yesterDaySuccess:
      "오늘의 리워드"
    case .todayFail, .yesterDayFail, .fewDaysFail:
      "미션 실패"
    }
  }
  
  var title: String {
    switch self {
    case .todaySuccess(let earnedPoint):
      """
      \(earnedPoint)pt
      리워드를 얻었어요!
      """
    case .todayFail:
      "아쉽게 미션을 실패했네요..."
    case .yesterDaySuccess(let earnedPoint):
      """
      어제 미션으로 \(earnedPoint)pt
      리워드를 얻었어요!
      """
    case .yesterDayFail:
      "아쉽게 어제 미션을 실패했어요..."
    case .fewDaysFail:
      """
      며칠 미션을 못 하셨지만...
      오늘 하면 메꿔드릴게요!
      """
    }
  }
  
  var gradientKeyword: String {
    switch self {
    case .todaySuccess(let earnedPoint):
      "\(earnedPoint)pt"
    case .todayFail:
      "아쉽게 미션을 실패했네요..."
    case .yesterDaySuccess(let earnedPoint):
      "\(earnedPoint)pt"
    case .yesterDayFail:
      "아쉽게 어제 미션을 실패했어요..."
    case .fewDaysFail:
      "며칠 미션을 못 하셨지만..."
    }
  }
  
  var styleAppliedTitle: AttributedString {
    let title = self.title
    let keyword = self.gradientKeyword
    let highlightGradient = LinearGradient.LinearType.text01
    
    var attributedString = AttributedString(title)
    attributedString.foregroundColor = ColorResource.Text.main.color
    attributedString = attributedString.applyGradient(highlightGradient, to: keyword)
    
    return attributedString
  }
  
  var description: String? {
    switch self {
    case .todaySuccess, .yesterDaySuccess:
      nil
    case .todayFail:
      """
      하지만 내일 미션을 성공하면
      리워드가 두배예요!
      """
    case .yesterDayFail:
      """
      하지만 오늘 미션을 성공하면
      리워드가 두배예요!
      """
    case .fewDaysFail:
      """
      특별히 오늘 미션을 완수하면
      보상을 4배나 드려요
      """
    }
  }
  
  var image: Image {
    switch self {
    case .todaySuccess, .yesterDaySuccess:
      ImageResource.fireworks.image
    case .todayFail, .yesterDayFail, .fewDaysFail:
      ImageResource.fireworks.image // TODO: 이미지 디자인 업데이트 후 변경 필요
    }
  }
}
