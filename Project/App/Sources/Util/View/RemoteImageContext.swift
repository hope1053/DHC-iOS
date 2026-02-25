//
//  RemoteImageContext.swift
//  Flifin
//
//  Created by Codex on 2/25/26.
//

import Foundation

import SDWebImage
import SDWebImageSVGCoder

enum RemoteImageContext {
  static func context(for url: URL?) -> [SDWebImageContextOption: Any]? {
    guard let url, url.isSVG else {
      return nil
    }

    return [
      .imageCoder: SDImageSVGCoder.shared
    ]
  }
}
