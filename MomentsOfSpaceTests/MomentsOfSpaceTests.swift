//
//  MeditationListTests.swift
//  MomentsOfSpaceTests
//
//  Created by Ivan on 2/9/23.
//

import Combine
import CoreLocation
import ComposableArchitecture
import XCTest
@testable import MomentsOfSpace


@MainActor
final class LocationTests: XCTestCase {
    
    func location(value: CLLocationDegrees) -> Location {
        Location(clLocation: .init(latitude: value, longitude: value))
    }
    
    func testOnLocationOnlySendsOnDistinctValues() async throws {
        let store = TestStore(initialState: .init()) {
            LocationFeature()
        }
        
        await store.send(.onLocation(location(value: 2))) {
            $0.currentLocation = self.location(value: 2)
        }
        
        await store.receive(.delegate(.onLocationChange(self.location(value: 2))))
        
        await store.send(.onLocation(location(value: 2)))
    }

    func testWhenRequestAuthorizationNotifiesDelegate() async throws {
        let statusStream = AsyncStream.makeStream(of: CLAuthorizationStatus.self)
        var askForPermissionCalled = false

        let store = TestStore(initialState: .init(currentStatus: .notDetermined)) {
            LocationFeature()
        } withDependencies: {
            $0.locationClient = .init(askForPermission: {
                askForPermissionCalled = true
            }, locations: {
                .never
            }, statuses: {
                statusStream.stream
            })
        }

        await store.send(.task)

        await store.send(.locationTapped)
        XCTAssertTrue(askForPermissionCalled)

        statusStream.continuation.yield(.authorizedAlways)
        await store.receive(.onStatus(.authorizedAlways)) {
            $0.currentStatus = .authorizedAlways
        }

        await store.receive(.delegate(.onStatusChange(.authorizedAlways)))
        await store.skipInFlightEffects()
    }
}
