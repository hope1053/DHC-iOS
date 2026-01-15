//
//  PopupModifier.swift
//  Flifin
//
//  Created by hyerin on 1/14/26.
//

import SwiftUI

public struct PopupModifier<PopupContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let popupContent: () -> PopupContent
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        if isPresented {
          ZStack {
            ColorResource._0_F_1114.color
              .ignoresSafeArea()
              .onTapGesture {
                withAnimation {
                  isPresented = false
                }
              }
            
            popupContent()
              .padding(.horizontal, 40)
              .transition(.scale.combined(with: .opacity))
          }
          .zIndex(999)
        }
      }
      .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
  }
}

extension View {
  func popup<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        popupContent: content
      )
    )
  }
}


