//
//  DHCToast.swift
//  Flifin
//
//  Created by 김유빈 on 7/1/25.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let type: ToastType
  let time: CGFloat
  
  @State private var workItem: DispatchWorkItem?
  
  public func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottom) {
        if isPresented {
          ToastView(
            type: type,
            backgroundColor: ColorResource.Neutral._500.color,
            cornerRadius: 12,
            textStyle: Typography.Body.body4,
            textColor: ColorResource.Text.main.color
          )
          .padding(.horizontal, 20)
          .padding(.bottom, 24)
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .zIndex(999)
        }
      }
      .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
      .onChange(of: isPresented) { _, newValue in
        guard newValue else { return }
        
        workItem?.cancel()
        
        let task = DispatchWorkItem {
          withAnimation {
            isPresented = false
          }
        }
        workItem = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: task)
      }
  }
}

extension View {
  func toast(
    isPresented: Binding<Bool>,
    type: ToastType,
    time: CGFloat = 2.0
  ) -> some View {
    self.modifier(
      ToastModifier(
        isPresented: isPresented,
        type: type,
        time: time
      )
    )
  }
}
