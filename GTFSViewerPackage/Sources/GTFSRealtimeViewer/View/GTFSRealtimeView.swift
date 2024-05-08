//
//  GTFSRealtimeView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import SwiftUI

public struct GTFSRealtimeView: View {
    @State private var presenter: GTFSRealtimePresenter = .init()

    public init() {}

    public var body: some View {
        NavigationSplitView {
            ControllerView(presenter: presenter)
                .navigationTitle("GTFS Realtime")
        } detail: {
            MapView(presenter: presenter)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Group {
                            switch presenter.mapViewMode {
                            case let .agency(presenter):
                                Text("Agency ID: \(presenter.agencyID)")

                            case let .vehicle(presenter):
                                Text("Agency ID: \(presenter.agencyID)")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        VStack(alignment: .trailing) {
                            switch presenter.mapViewMode {
                            case let .agency(presenter):
                                Text("From: \(presenter.rangeStartDateString)")
                                Text("To: \(presenter.rangeEndDateString)")

                            case let .vehicle(presenter):
                                Text("From: \(DateFormatter.iso8601.string(from: presenter.timestampFrom))")
                                Text("To: \(DateFormatter.iso8601.string(from: presenter.timestampTo))")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
        }
        .task {
            presenter.isLoading = true
            await presenter.changeMapViewModeToAgency()
            presenter.mapCameraPosition = .region(.init(presenter.vehicleCoordinates))
            await presenter.startFetchingVehiclePositions()
        }
        .alert(
            "Something went wrong.",
            isPresented: $presenter.isAlertShowing,
            presenting: presenter.alertString,
            actions: { _ in },
            message: Text.init
        )
    }
}

#if DEBUG
#Preview {
    GTFSRealtimeView()
}
#endif
