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
                .toolbar(.hidden)
        }
        .task {
            presenter.isLoading = true
            await presenter.changeMapViewModeToAgency()
            await presenter.startFetchingVehiclePositions()
        }
        .alert(
            String(localized: "Something went wrong.", bundle: .module),
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
