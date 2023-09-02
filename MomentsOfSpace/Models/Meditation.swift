//
//  Meditation.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import Foundation

struct Meditation: Decodable, Equatable, Identifiable {
    let id: Int
    let audioFiles: [AudioFile]
    let title: String
    let subtitle: String
    let description: String

    var durationInMinutes: Int {
        audioFiles.map(\.duration).reduce(0, +).minutes
    }
}

extension Meditation {
    static let mock = Meditation(
        id: 1,
        audioFiles: [.mock],
        title: "Mellow Out",
        subtitle: "Emotion",
        description: "Wind down and rest with the sand between your toes."
    )
}

extension Array where Element == Meditation {
    static let mock = [
        Meditation.mock,
        .init(
            id: 2,
            audioFiles: [.mock],
            title: "Allow That",
            subtitle: "Acceptance",
            description: "Wind down and rest with the sand between your toes."
        ),
        .init(
            id: 3,
            audioFiles: [.mock],
            title: "Energy in Emotion",
            subtitle: "Emotion",
            description: "Wind down and rest with the sand between your toes."
        ),
        .init(
            id: 4,
            audioFiles: [.mock],
            title: "Calm it",
            subtitle: "Anxiety",
            description: "Wind down and rest with the sand between your toes."
        ),
    ]

    static func mock(location: Location) -> [Meditation] { [
        Meditation.mock,
        .init(
            id: 2,
            audioFiles: [.mock],
            title: "Allow That",
            subtitle: "Acceptance",
            description: "Wind down and rest with the sand between your toes."
        ),
        .init(
            id: 3,
            audioFiles: [.mock],
            title: "Energy in Emotion",
            subtitle: "Emotion",
            description: "Wind down and rest with the sand between your toes."
        ),
        .init(
            id: 4,
            audioFiles: [.mock],
            title: "Calm it",
            subtitle: "Anxiety",
            description: "Wind down and rest with the sand between your toes."
        ),
    ]}
}
