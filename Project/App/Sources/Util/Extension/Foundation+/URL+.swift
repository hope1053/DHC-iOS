//
//  URL+.swift
//  Flifin
//
//  Created by hyerin on 2/20/26.
//

import Foundation

extension URL {
  init?(string: String?) {
    if let string, let url = URL(string: string) {
      self = url
    } else {
      return nil
    }
  }
}
