//
//  TodayMissionView.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import SwiftUI

struct TodayMissionView: View {
  let remainingSeconds: Int
  
  var body: some View {
    VStack(spacing: 24) {
      TodayMissionTimerView(remainingSeconds: remainingSeconds)
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
    .padding(.bottom, 40)
  }
}

struct TodayMissionTimerView: View {
  let remainingSeconds: Int
  
  var body: some View {
    VStack(spacing: 0) {
      Text("오늘 미션 종료까지")
        .textStyle(.body4)
        .foregroundStyle(ColorResource.Text.Body.primary.color)
        .opacity(0.4)
      
      Text("\(remainingSeconds.formattedTime) 남음")
        .textStyle(.h2_1)
        .foregroundStyle(ColorResource.Text.main.color)
    }
    .frame(alignment: .center)
    .monospacedDigit()
  }
}

extension Int {
  fileprivate var formattedTime: String {
    let hours = self / 3600
    let minutes = (self % 3600) / 60
    let seconds = self % 60
    return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
  }
}
