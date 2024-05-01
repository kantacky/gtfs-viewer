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
    var selectedVehicle: VehiclePosition?
    var mapViewMode: MapViewMode = .agency(presenter: AgencyPresenter(agencyID: agencyID, fetch: {}))
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

    func fetchVehiclePositions() async {
        defer { isLoading = false }
        do {
            switch mapViewMode {
            case let .agency(presenter):
                vehiclePositions = try await apiClient.listVehiclesPositions(
                    agencyID: presenter.agencyID,
                    timestamp: presenter.timestamp,
                    bufferSeconds: presenter.bufferSeconds
                )

            case let .vehicle(presenter):
                vehiclePositions = try await apiClient.listVehiclePositions(
                    agencyID: presenter.agencyID,
                    vehicleID: presenter.vehicleID,
                    timestampFrom: presenter.timestampFrom,
                    timestampTo: presenter.timestampTo
                )
            }
        } catch {
            alertString = String(localized: "Failed to fetch vehicle positions.", bundle: .module) + "\n" + error.localizedDescription
        }
    }

    func startFetchingVehiclePositions() async {
        while true {
            try? await Task.sleep(nanoseconds: 10_000_000_000)
            await fetchVehiclePositions()
        }
    }

    private func changeMapViewMode(to mode: MapViewMode) async {
        selectedVehicle = nil
        mapViewMode = mode
        await fetchVehiclePositions()
    }

    func changeMapViewModeToAgency() async {
        await changeMapViewMode(
            to: .agency(
                presenter: AgencyPresenter(
                    agencyID: agencyID,
                    fetch: fetchVehiclePositions
                )
            )
        )
    }

    func changeMapViewModeToVehicle(vehicleID: String) async {
        await changeMapViewMode(
            to: .vehicle(
                presenter: VehiclePresenter(
                    agencyID: agencyID,
                    vehicleID: vehicleID,
                    back: changeMapViewModeToAgency,
                    fetch: fetchVehiclePositions
                )
            )
        )
    }
}
