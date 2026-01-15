//
//  Text+GradientStyle.swift
//  Flifin
//
//  Created by hyerin on 1/14/26.
//

import SwiftUI

extension Text {
  init(_ attributedString: AttributedString) {
    let runs = Array(attributedString.runs)
    
    guard !runs.isEmpty else {
      self.init(verbatim: "")
      return
    }
    
    var combinedText: Text?
    
    for run in runs {
      let substring = String(attributedString[run.range].characters)
      let runText = Text(verbatim: substring)
      
      let styledText: Text
      if let gradientType = run.gradientStyle {
        styledText = runText.foregroundStyle(
          LinearGradient(
            gradientType,
            startPoint: .top,
            endPoint: .bottom
          )
        )
      } else if let color = run.foregroundColor {
        styledText = runText.foregroundColor(color)
      } else {
        styledText = runText
      }
      
      if let existing = combinedText {
        combinedText = existing + styledText
      } else {
        combinedText = styledText
      }
    }
    
    self = combinedText ?? Text(verbatim: "")
  }
}

