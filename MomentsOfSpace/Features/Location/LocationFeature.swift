//
//  LocationFeature.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import ComposableArchitecture
import CoreLocation
import Foundation

struct LocationFeature: Reducer {
    struct State: Equatable {
        var currentStatus: CLAuthorizationStatus = .notDetermined
        var currentLocation: Location?
    }

    enum Action: Equatable {
        enum Delegate: Equatable {
            case onLocationChange(Location?)
            case onStatusChange(CLAuthorizationStatus)
        }
        case delegate(Delegate)
        case locationTapped
        case onLocation(Location?)
        case onStatus(CLAuthorizationStatus)
        case task
    }

    @Dependency(\.locationClient) var locationClient
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .delegate:
                return .none

            case .locationTapped:
                return .run { _ in
                    await self.locationClient.askForPermission()
                }

            case .onLocation(let location):
                let previousLocation = state.currentLocation
                if previousLocation != location {
                    state.currentLocation = location
                    return .send(.delegate(.onLocationChange(location)))
                }
                return .none

            case .onStatus(let status):
                let previousStatus = state.currentStatus
                if previousStatus != status {
                    state.currentStatus = status
                    return .send(.delegate(.onStatusChange(status)))
                }
                return .none

            case .task:
                return .merge(
                    .run { send in
                        for await status in await locationClient.statuses() {
                            await send(.onStatus(status))
                        }
                    },
                    .run { send in
                        for await location in await locationClient.locations() {
                            await send(.onLocation(location.map(Location.init)))
                        }
                    }
                )
            }
        }
    }
}
