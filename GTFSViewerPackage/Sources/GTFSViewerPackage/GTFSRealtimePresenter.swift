//
//  GTFSRealtimePresenter.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import APIClient
import Dependencies
import Foundation
import GTFSViewerEntity
import GTFSViewerUtility
import Observation

private let agencyID: UUID = UUID(uuidString: "24af33ea-704d-4baf-a906-70042ae61bc5")!

@Observable
class GTFSRealtimePresenter {
    var vehiclePositions: [VehiclePosition] = []
    var isTrackingCurrentTime: Bool = true
    var timestamp: Date = .now
    var bufferSeconds: Int = 300
    var selectedVehicle: VehiclePosition?
    var mapViewMode: MapViewMode = .agency(agencyID: agencyID)
    var isLoading: Bool = false
    var alertString: String?
    var isAlertShowing: Bool {
        get {
            alertString != nil
        }
        set {
            if !newValue {
                alertString = nil
            }
        }
    }

    @ObservationIgnored @Dependency(APIClient.self) private var apiClient: APIClient

    var rangeStartDateString: String {
        DateFormatter.iso8601.string(from: timestamp - TimeInterval(bufferSeconds))
    }
    var rangeEndDateString: String {
        DateFormatter.iso8601.string(from: timestamp)
    }

    func fetchVehiclePositions() async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch mapViewMode {
            case let .agency(agencyID):
                vehiclePositions = try await apiClient.listVehiclesPositions(
                    agencyID: agencyID,
                    timestamp: timestamp,
                    bufferSeconds: bufferSeconds
                )

            case let .vehicle(agencyID, vehicleID):
                vehiclePositions = try await apiClient.listVehiclePositions(
                    agencyID: agencyID,
                    vehicleID: vehicleID,
                    timestampFrom: timestamp - TimeInterval(bufferSeconds),
                    timestampTo: timestamp
                )
            }
        } catch {
            alertString = String(localized: "Failed to fetch vehicle positions.", bundle: .module) + "\n" + error.localizedDescription
        }
    }

    func startFetchingVehiclePositions() async {
        while(true) {
            if isTrackingCurrentTime {
                timestamp = .now
                await fetchVehiclePositions()
            }
            try? await Task.sleep(nanoseconds: 10_000_000_000)
        }
    }

    func watchVehiclePosition(_ vehiclePosition: VehiclePosition) async {
        selectedVehicle = nil
        mapViewMode = .vehicle(agencyID: agencyID, vehicleID: vehiclePosition.vehicleID)
        await fetchVehiclePositions()
    }

    func backToAgencyMode() async {
        mapViewMode = .agency(agencyID: agencyID)
        await fetchVehiclePositions()
    }
}
