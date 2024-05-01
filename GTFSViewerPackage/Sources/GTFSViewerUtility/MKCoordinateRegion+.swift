//
//  MKCoordinateRegion+.swift
//
//
//  Created by Kanta Oikawa on 2024/05/02.
//

import MapKit

public extension MKCoordinateRegion {
    init(_ coordinates: [CLLocationCoordinate2D]) {
        let minLatitude: Double = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? -90
        let maxLatitude: Double = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 90
        let minLongitude: Double = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? -180
        let maxLongitude: Double = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 180

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: maxLatitude - minLatitude,
            longitudeDelta: maxLongitude - minLongitude
        )
        self = .init()
        self.center = center
        self.span = span
    }
}
