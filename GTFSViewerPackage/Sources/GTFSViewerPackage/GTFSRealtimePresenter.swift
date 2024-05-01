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

@Observable
class GTFSRealtimePresenter {
    var vehiclePositions: [VehiclePosition] = []
    var isTrackingCurrentTime: Bool = true
    var timestamp: Date = .now
    var bufferSeconds: Int = 300
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
            vehiclePositions = try await apiClient.listVehiclesPositions(
                agencyID: UUID(uuidString: "24af33ea-704d-4baf-a906-70042ae61bc5")!,
                timestamp: timestamp,
                bufferSeconds: bufferSeconds
            )
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
}
