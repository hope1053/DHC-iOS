//
//  ToastType.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import SwiftUI

enum ToastType: Equatable {
  case textWithCheck(String)
  case imageAndText(Image, String)
}
