//
//  LocationClient.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import Combine
import CoreLocation
import Dependencies
import Foundation

struct LocationClient {
    var askForPermission: () async -> Void
    var locations: () async -> AsyncStream<CLLocation?>
    var statuses: () async -> AsyncStream<CLAuthorizationStatus>
}

final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let locationsSubject = PassthroughSubject<CLLocation?, Never>()
    let statusSubject: CurrentValueSubject<CLAuthorizationStatus, Never>

    init(initialStatus: CLAuthorizationStatus) {
        self.statusSubject = .init(initialStatus)
        super.init()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationsSubject.send(nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationsSubject.send(location)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        statusSubject.send(manager.authorizationStatus)
    }
}

extension LocationClient: DependencyKey {
    static var liveValue:  LocationClient {

        let managerAndDelegate = MainActorIsolated(initialValue: {
            let manager = CLLocationManager()
            let delegate = LocationDelegate(initialStatus: manager.authorizationStatus)
            manager.delegate = delegate
            manager.startUpdatingLocation()
            return (manager: manager, delegate: delegate)
        }())

        return .init(
            askForPermission: {
                await managerAndDelegate.value.manager.requestWhenInUseAuthorization()
            }, locations: {
                await managerAndDelegate.value.delegate.locationsSubject.values.eraseToStream()
            }, statuses: {
                await managerAndDelegate.value.delegate.statusSubject.values.eraseToStream()
            }
        )
    }
}

extension DependencyValues {
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
