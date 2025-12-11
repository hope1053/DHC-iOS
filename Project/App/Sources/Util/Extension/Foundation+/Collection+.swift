//
//  Collection+.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import Foundation

extension Collection {
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
