//
//  TestBannerStorage.swift
//  Flifin
//
//  Created by hyerin on 2/5/26.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct TestBannerStorage {
  var getDismissedVersions: () -> Set<Int> = { Set() }
  var addDismissedVersion: (Int) -> Void
  var clearDismissedVersions: () -> Void
}

extension TestBannerStorage: DependencyKey {
  static var liveValue: TestBannerStorage = {
    @ObservationIgnored
    @Shared(.appStorage("dismissedTestBannerVersions")) var dismissedVersionsData: Data?
    
    return TestBannerStorage(
      getDismissedVersions: {
        guard let data = dismissedVersionsData,
              let versions = try? JSONDecoder().decode(Set<Int>.self, from: data) else {
          return []
        }
        return versions
      },
      addDismissedVersion: { version in
        $dismissedVersionsData.withLock { data in
          var versions: Set<Int> = []
          if let existingData = data,
             let existingVersions = try? JSONDecoder().decode(Set<Int>.self, from: existingData) {
            versions = existingVersions
          }
          versions.insert(version)
          data = try? JSONEncoder().encode(versions)
        }
      },
      clearDismissedVersions: {
        $dismissedVersionsData.withLock { data in
          data = nil
        }
      }
    )
  }()
  
  static let previewValue = TestBannerStorage(
    getDismissedVersions: { [] },
    addDismissedVersion: { _ in },
    clearDismissedVersions: {}
  )
  
  static let testValue = Self()
}

extension DependencyValues {
  var testBannerStorage: TestBannerStorage {
    get { self[TestBannerStorage.self] }
    set { self[TestBannerStorage.self] = newValue }
  }
}
