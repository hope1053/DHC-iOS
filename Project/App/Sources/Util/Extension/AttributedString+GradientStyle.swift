//
//  AttributedString+GradientStyle.swift
//  Flifin
//
//  Created by hyerin on 1/14/26.
//

import SwiftUI

enum GradientStyleAttribute: CodableAttributedStringKey, MarkdownDecodableAttributedStringKey {
  typealias Value = LinearGradient.LinearType
  static let name = "gradientStyle"
}

extension AttributeScopes {
  struct GradientStyleAttributes: AttributeScope {
    var gradientStyle: GradientStyleAttribute
  }
  
  var gradientStyleAttributes: GradientStyleAttributes.Type {
    GradientStyleAttributes.self
  }
}

extension AttributeDynamicLookup {
  subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeScopes.GradientStyleAttributes, T>) -> T {
    self[T.self]
  }
}

extension AttributedString {
  func applyGradient(_ gradient: LinearGradient.LinearType, to substring: String) -> AttributedString {
    var result = self
    
    if let range = result.range(of: substring) {
      result[range].gradientStyle = gradient
    }
    
    return result
  }
}

