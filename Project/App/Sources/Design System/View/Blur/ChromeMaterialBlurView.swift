//
//  ChromeMaterialBlurView.swift
//  Flifin
//
//  Created by Codex on 2/20/26.
//

import SwiftUI
import UIKit

struct ChromeMaterialBlurView: UIViewRepresentable {
  let style: UIBlurEffect.Style

  init(style: UIBlurEffect.Style = .systemChromeMaterialDark) {
    self.style = style
  }

  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView(effect: UIBlurEffect(style: style))
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
