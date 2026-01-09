//
//  RewardDetailView.swift
//  Flifin
//
//  Created by hyerin on 1/9/26.
//

import SwiftUI

import ComposableArchitecture

struct RewardDetailView: View {
  let store: StoreOf<RewardDetailReducer>
  
  init(store: StoreOf<RewardDetailReducer>) {
    self.store = store
  }
  
  var body: some View {
    Text("Hello, World!")
  }
}

#Preview {
  RewardDetailView(
    store: Store(
      initialState: .init(),
      reducer: RewardDetailReducer.init
    )
  )
}
