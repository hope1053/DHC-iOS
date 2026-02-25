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

  var isSVG: Bool {
    let lowercasedPathExtension = pathExtension.lowercased()
    if lowercasedPathExtension == "svg" || lowercasedPathExtension == "svgz" {
      return true
    }
    
    let lowercasedURLString = absoluteString.lowercased()
    if lowercasedURLString.contains(".svg") {
      return true
    }
    
    return query?
      .lowercased()
      .split(separator: "&")
      .contains(where: { item in
        item == "format=svg" || item == "type=svg" || item == "ext=svg"
      }) == true
  }
}
