//
//  LevelInfo.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import Foundation

struct LevelInfo: Equatable {
  let level: Int
  let name: String
  let threshold: Int
  
  init(
    level: Int,
    name: String,
    threshold: Int
  ) {
    self.level = level
    self.name = name
    self.threshold = threshold
  }
}

