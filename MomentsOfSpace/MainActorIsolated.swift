//
//  MainActorIsolated.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import Foundation

@MainActor
public final class MainActorIsolated<Value> {
    public lazy var value: Value = initialValue()
    private let initialValue: @MainActor () -> Value

    nonisolated public init(initialValue: @MainActor @autoclosure @escaping () -> Value) {
        self.initialValue = initialValue
    }
}
