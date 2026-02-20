//
//  ShareClient.swift
//  Flifin
//
//  Created by hyerin on 1/19/26.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct ShareClient: Sendable {
  var createShareCode: (_ userId: String) async throws -> String
}

extension ShareClient: DependencyKey {
  static var liveValue: ShareClient {
    let networkManager = NetworkManager()
    return ShareClient(
      createShareCode: { userId in
        let endpoint = ShareAPI.createShareCode(userId: userId)
        
        return try await networkManager
          .request(endpoint)
          .map(to: ShareCodeResponseDTO.self)
          .toDomain
      }
    )
  }
  
  static let previewValue = ShareClient(
    createShareCode: { _ in
      "abc123def456"
    }
  )
  
  static let testValue = ShareClient()
}

extension DependencyValues {
  var shareClient: ShareClient {
    get { self[ShareClient.self] }
    set { self[ShareClient.self] = newValue }
  }
}
