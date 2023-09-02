//
//  LocationView.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import ComposableArchitecture
import SwiftUI

private enum Layout {
    static let frame = CGSize(width: 40, height: 40)
}

struct LocationButton: View {
    let store: StoreOf<LocationFeature>

    var body: some View {
        Button {
            store.send(.locationTapped)
        } label: {
            Image(systemName: "location.circle")
                .font(.system(size: 32, weight: .thin))
                .foregroundColor(.gray4)
        }
        .task {
            store.send(.task)
        }
    }
}

struct LocationButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationButton(store: .init(initialState: .init()) {
            LocationFeature()
        })
    }
}
