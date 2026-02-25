//
//  FlifinApp.swift
//  Flifin
//
//  Created by 최혜린 on 4/14/25.
//

import SwiftUI

import ComposableArchitecture
import SDWebImage
import SDWebImageSVGCoder

@main
struct FlifinApp: App {
  init() {
    SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
  }

	var body: some Scene {
		WindowGroup {
      RootView(
        store: Store(
          initialState: RootReducer.State(),
          reducer: RootReducer.init
        )
      )
		}
	}
}
