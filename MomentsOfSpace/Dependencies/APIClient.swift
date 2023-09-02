//
//  APIClient.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import Dependencies
import Foundation

struct APIClient {
    var fetchMeditations: (Location?) async throws -> [Meditation]
}

extension APIClient: DependencyKey {
    static let liveValue = APIClient(fetchMeditations: { _ in
        try await Task.sleep(for: .seconds(2))
        return [Meditation].mock.shuffled()  // Shuffle will simulate new API results
    })

    static let testValue = APIClient { _ in
        unimplemented("API Client")
    }

    static let previewValue = APIClient { _ in
        return .mock
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
