//
//  VehiclePosition.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import CoreLocation

public struct VehiclePosition: Identifiable {
    public let id: UUID
    public let tripID: String
    public let routeID: String
    public let directionID: Int
    public let scheduleRelationship: String
    public let vehicleID: String
    public let vehicleLabel: String
    public let vehiclePosition: CLLocationCoordinate2D
    public let currentStopSequence: Int
    public let stopID: String
    public let timestamp: Date

    public init(
        id: UUID,
        tripID: String,
        routeID: String,
        directionID: Int,
        scheduleRelationship: String,
        vehicleID: String,
        vehicleLabel: String,
        vehiclePosition: CLLocationCoordinate2D,
        currentStopSequence: Int,
        stopID: String,
        timestamp: Date
    ) {
        self.id = id
        self.tripID = tripID
        self.routeID = routeID
        self.directionID = directionID
        self.scheduleRelationship = scheduleRelationship
        self.vehicleID = vehicleID
        self.vehicleLabel = vehicleLabel
        self.vehiclePosition = vehiclePosition
        self.currentStopSequence = currentStopSequence
        self.stopID = stopID
        self.timestamp = timestamp
    }
}

#if DEBUG
public extension VehiclePosition {
    static let mock1 = VehiclePosition(
        id: .init(),
        tripID: "T000",
        routeID: "R000",
        directionID: 0,
        scheduleRelationship: "SCHEDULED",
        vehicleID: "V000",
        vehicleLabel: "V000",
        vehiclePosition: .init(latitude: 35.680281, longitude: 139.769562),
        currentStopSequence: 0,
        stopID: "S000",
        timestamp: .now
    )
    static let mock2 = VehiclePosition(
        id: .init(),
        tripID: "T001",
        routeID: "R001",
        directionID: 0,
        scheduleRelationship: "SCHEDULED",
        vehicleID: "V001",
        vehicleLabel: "V001",
        vehiclePosition: .init(latitude: 35.678449, longitude: 139.773443),
        currentStopSequence: 0,
        stopID: "S001",
        timestamp: .now
    )
    static let mock3 = VehiclePosition(
        id: .init(),
        tripID: "T002",
        routeID: "R002",
        directionID: 0,
        scheduleRelationship: "SCHEDULED",
        vehicleID: "V002",
        vehicleLabel: "V002",
        vehiclePosition: .init(latitude: 35.674951, longitude: 139.759554),
        currentStopSequence: 0,
        stopID: "S002",
        timestamp: .now
    )
    static let mock4 = VehiclePosition(
        id: .init(),
        tripID: "T003",
        routeID: "R003",
        directionID: 0,
        scheduleRelationship: "SCHEDULED",
        vehicleID: "V003",
        vehicleLabel: "V003",
        vehiclePosition: .init(latitude: 35.670180, longitude: 139.774918),
        currentStopSequence: 0,
        stopID: "S003",
        timestamp: .now
    )
    static let mock5 = VehiclePosition(
        id: .init(),
        tripID: "T004",
        routeID: "R004",
        directionID: 0,
        scheduleRelationship: "SCHEDULED",
        vehicleID: "V004",
        vehicleLabel: "V004",
        vehiclePosition: .init(latitude: 35.682635, longitude: 139.782212),
        currentStopSequence: 0,
        stopID: "S004",
        timestamp: .now
    )
}
#endif
