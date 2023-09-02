//
//  CLAuthorizationStatus+.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import CoreLocation

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(self)
    }
}
