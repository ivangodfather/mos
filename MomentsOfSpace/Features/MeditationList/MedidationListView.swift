//
//  MeditationListView.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import ComposableArchitecture
import SwiftUI

private typealias MeditationViewStore =  ViewStore<MeditationListView.ViewState, MeditationListFeature.Action>

struct MeditationListView: View {
    let store: StoreOf<MeditationListFeature>

    var body: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            VStack(alignment: .leading, spacing: .Padding.medium) {
                TitleView(text: "Meditations")
                    .padding(.horizontal, .Padding.big)
                contentView(using: viewStore)
            }
            .frame(maxWidth: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LocationButton(store: store.scope(state: \.location, action: { .location($0) }))
                }
            }
            .task {
                viewStore.send(.task)
            }
        }
    }

    @ViewBuilder
    private func contentView(using viewStore: MeditationViewStore) -> some View {
        Group {
            switch viewStore.viewState {
            case .empty:
                Text("No data!")
            case .isLoading:
                ProgressView()
            case .successful(let meditations):
                ScrollView {
                    VStack(spacing: .Padding.medium) {
                        ForEach(
                            meditations,
                            content: MeditationListRowView.init
                        )
                    }
                    .padding(.Padding.big)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    struct ViewState: Equatable {
        let viewState: ViewState

        enum ViewState: Equatable {
            case empty
            case isLoading
            case successful(IdentifiedArrayOf<Meditation>)
        }

        init(_ state: MeditationListFeature.State) {
            switch(state.isLoading, state.meditations) {
            case (true, _):
                viewState = .isLoading
            case (false, []):
                viewState = .empty
            case (false, let meditations):
                viewState = .successful(meditations)
            }
        }
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeditationListView(store: .init(initialState: .init()) {
                MeditationListFeature()
            })
        }
    }
}
