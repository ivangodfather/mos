//
//  Location.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import CoreLocation

struct Location: Equatable {
    let clLocation: CLLocation

    init(clLocation: CLLocation) {
        self.clLocation = clLocation
    }
    func distance(from other: Location) -> Double {
        self.clLocation.distance(from: other.clLocation)
    }

    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.clLocation.coordinate.latitude == rhs.clLocation.coordinate.latitude && lhs.clLocation.coordinate.longitude == rhs.clLocation.coordinate.longitude
    }
}
