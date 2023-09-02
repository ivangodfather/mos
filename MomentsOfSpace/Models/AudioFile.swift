//
//  AudioFile.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import Foundation

struct AudioFile: Decodable, Equatable {
    let id: Int
    let name: String
    let audio: URL
    let version: String
    let duration: Int
}

extension AudioFile {
    static let mock = AudioFile(
        id: 101,
        name: "Audio name",
        audio: URL(string: "https://api.momentsofspace.com/api/audio/101/download/")!,
        version: "1.0",
        duration: 527
    )
}
