//
//  BundleResource.swift
//  Flifin
//
//  Created by 최혜린 on 7/2/25.
//

import Foundation

extension URL {
  enum Resource {
    case fortuneCardFrontDefaultView
    case fortuneCardBackView
    case clover
    case knife
    case greenFace
    case redFace
    case love
    case money
    case study
    case tree
    case fire
    case soil
    case gold
    case water
    case splashLottie
    case onboardingVideo
    case fortuneLoadingVideo
    case lock
  }
  
  static func urlForResource(_ resource: Resource) -> URL? {
    switch resource {
    case .fortuneCardFrontDefaultView:
      return Bundle.main.url(forResource: "fortuneCardFrontDefaultView", withExtension: "png")
    case .fortuneCardBackView:
      return Bundle.main.url(forResource: "fortuneCardBackView", withExtension: "png")
    case .splashLottie:
      return Bundle.main.url(forResource: "splash", withExtension: "json")
    case .clover:
      return Bundle.main.url(forResource: "clover", withExtension: "png")
    case .knife:
      return Bundle.main.url(forResource: "knife", withExtension: "png")
    case .greenFace:
      return Bundle.main.url(forResource: "greenFace", withExtension: "png")
    case .redFace:
      return Bundle.main.url(forResource: "redFace", withExtension: "png")
    case .love:
      return Bundle.main.url(forResource: "love", withExtension: "png")
    case .money:
      return Bundle.main.url(forResource: "money", withExtension: "png")
    case .study:
      return Bundle.main.url(forResource: "study", withExtension: "png")
    case .tree:
      return Bundle.main.url(forResource: "tree", withExtension: "png")
    case .fire:
      return Bundle.main.url(forResource: "fire", withExtension: "png")
    case .soil:
      return Bundle.main.url(forResource: "soil", withExtension: "png")
    case .gold:
      return Bundle.main.url(forResource: "gold", withExtension: "png")
    case .water:
      return Bundle.main.url(forResource: "water", withExtension: "png")
    case .onboardingVideo:
      return Bundle.main.url(forResource: "onboardingVideo", withExtension: "mp4")
    case .fortuneLoadingVideo:
      return Bundle.main.url(forResource: "fortuneLoading", withExtension: "mp4")
    case .lock:
      return Bundle.main.url(forResource: "lock", withExtension: "png")
    }
  }
}
