//
//  RewardView.swift
//  Flifin
//
//  Created by hyerin on 12/11/25.
//

import SwiftUI

import ComposableArchitecture

struct RewardView: View {
  let store: StoreOf<RewardReducer>
  
  init(store: StoreOf<RewardReducer>) {
    self.store = store
  }
  
  var body: some View {
    Text("Hello, World!")
  }
}

#Preview {
  RewardView(
    store: Store(
      initialState: .init(),
      reducer: RewardReducer.init
    )
  )
}
