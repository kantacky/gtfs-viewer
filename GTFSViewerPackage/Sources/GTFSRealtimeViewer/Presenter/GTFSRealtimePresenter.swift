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
import _MapKit_SwiftUI
import Observation

private let agencyID: UUID = UUID(uuidString: "24af33ea-704d-4baf-a906-70042ae61bc5")!

@Observable
class GTFSRealtimePresenter {
    var mapCameraPosition: MapCameraPosition = .region(.init([]))
    var vehiclePositions: [VehiclePosition] = []
    var vehicleCoordinates: [CLLocationCoordinate2D] { vehiclePositions.map(\.vehiclePosition) }
    var selectedVehicle: VehiclePosition?
    var mapViewMode: Mode = .agency(presenter: AgencyControllerPresenter(agencyID: agencyID, fetch: {}))
    var isLoading: Bool = false
    var alertString: String?
    var isAlertShowing: Bool {
        get { alertString != nil }
        set {
            if !newValue {
                alertString = nil
            }
        }
    }

    @ObservationIgnored @Dependency(APIClient.self) private var apiClient: APIClient

    init() {}

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

            if let selectedVehicle {
                let vehicle = vehiclePositions.first(where: { $0.vehicleID == selectedVehicle.vehicleID })
                selectVehicle(vehiclePosition: vehicle)
            }
        } catch {
            alertString = "Failed to fetch vehicle positions." + "\n" + error.localizedDescription
        }
    }

    func startFetchingVehiclePositions() async {
        while true {
            try? await Task.sleep(nanoseconds: 10_000_000_000)

            switch mapViewMode {
            case let .agency(presenter):
                if presenter.isTrackingNow {
                    presenter.timestamp = .now
                    await fetchVehiclePositions()
                }

            default:
                break
            }
        }
    }

    private func changeMapViewMode(to mode: Mode) async {
        mapViewMode = mode
        await fetchVehiclePositions()
    }

    func changeMapViewModeToAgency() async {
        await changeMapViewMode(
            to: .agency(
                presenter: AgencyControllerPresenter(
                    agencyID: agencyID,
                    fetch: fetchVehiclePositions
                )
            )
        )
    }

    func changeMapViewModeToVehicle(vehicleID: String) async {
        await changeMapViewMode(
            to: .vehicle(
                presenter: VehicleControllerPresenter(
                    agencyID: agencyID,
                    vehicleID: vehicleID,
                    back: changeMapViewModeToAgency,
                    fetch: fetchVehiclePositions
                )
            )
        )
    }

    func selectVehicle(vehiclePosition: VehiclePosition?) {
        self.selectedVehicle = vehiclePosition
        guard let vehiclePosition else {
            return
        }
        mapCameraPosition = .camera(
            MapCamera(
                centerCoordinate: vehiclePosition.vehiclePosition,
                distance: 10000
            )
        )
    }
}
