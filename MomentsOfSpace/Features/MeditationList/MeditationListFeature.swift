//
//  MeditationListFeature.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import ComposableArchitecture

private let locationThreshold: Double = 100

struct MeditationListFeature: Reducer {
    struct State {
        var isLoading = false
        var location = LocationFeature.State()
        var meditations = IdentifiedArrayOf<Meditation>()
        var meditationsLocation: Location?
    }

    enum Action {
        case fetchedMeditationsResponse(TaskResult<FetchedMeditations>)
        case location(LocationFeature.Action)
        case task
    }

    struct FetchedMeditations: Equatable {
        let location: Location?
        let mediations: IdentifiedArrayOf<Meditation>
    }

    @Dependency(\.apiClient) var apiClient

    var body: some ReducerOf<Self> {
        Scope(state: \.location, action: /Action.location) {
            LocationFeature()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case .fetchedMeditationsResponse(.success(let fetchedMeditations)):
                state.isLoading = false
                state.meditations = fetchedMeditations.mediations
                state.meditationsLocation = fetchedMeditations.location
                return .none

            case .fetchedMeditationsResponse(.failure):
                state.isLoading = false
                return .none

            case let .location(.delegate(.onLocationChange(location))):
                return checkLocationThreshold(state: &state, for: location)

            case .location:
                return .none
                
            case .task:
                return requestNewMeditations(state: &state, location: nil)
            }
        }
    }

    private func requestNewMeditations(state: inout State, location: Location?) -> Effect<Action> {
        state.isLoading = state.meditations.isEmpty
        return .run { send in
            await send(
                .fetchedMeditationsResponse(
                    TaskResult {
                        let meditations = try await apiClient.fetchMeditations(location)
                        return .init(location: location, mediations: .init(uniqueElements: meditations))
                    }
                ),
                animation: .default
            )
        }
    }

    private func checkLocationThreshold(state: inout State, for location: Location?) -> Effect<Action> {
        switch (state.meditationsLocation, location) {
        case (.some, nil):
            state.isLoading = false
            return .none
        case (nil, nil):
            guard state.meditations.isEmpty && !state.isLoading else {
                return .none
            }
            return requestNewMeditations(state: &state, location: nil)
        case (nil, .some(let current)):
            return requestNewMeditations(state: &state, location: current)
        case (.some(let previous), .some(let current)):
            if previous.distance(from: current) > locationThreshold {
                return requestNewMeditations(state: &state, location: current)
            }
            return .none
        }
    }
}


