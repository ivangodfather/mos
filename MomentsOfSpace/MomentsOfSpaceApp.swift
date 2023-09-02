//
//  MomentsOfSpaceApp.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import SwiftUI
import XCTestDynamicOverlay

@main
struct MomentsOfSpaceApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                NavigationStack {
                    MeditationListView(store: .init(initialState: .init()) {
                        MeditationListFeature()._printChanges()
                    })
                }
            }

        }
    }
}
