//
//  ShareCodeResponseDTO.swift
//  Flifin
//
//  Created by hyerin on 1/19/26.
//

import Foundation

struct ShareCodeResponseDTO: Decodable {
  let shareCode: String
}

extension ShareCodeResponseDTO {
  var toDomain: String {
    shareCode
  }
}

