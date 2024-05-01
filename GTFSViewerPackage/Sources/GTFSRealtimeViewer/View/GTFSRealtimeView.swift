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
        HStack(spacing: .zero) {
            ControllerView(presenter: presenter)
                .containerRelativeFrame(.horizontal, count: 4, span: 1, spacing: 0)

            MapView(presenter: presenter)
                .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
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
