//
//  Tip.swift
//  Flifin
//
//  Created by hyerin on 2/20/26.
//

import SwiftUI

struct Tip: Identifiable, Hashable {
  var id: String { title }
  let imageURL: URL?
  let title: String
  let content: String
  let contentColor: Color?
}
