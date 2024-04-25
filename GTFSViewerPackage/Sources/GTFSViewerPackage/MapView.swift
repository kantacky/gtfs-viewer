//
//  MapView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Binding private var presenter: GTFSRealtimePresenter

    init(presenter: Binding<GTFSRealtimePresenter>) {
        self._presenter = presenter
    }

    var body: some View {
        Map {
            ForEach(presenter.vehiclePositions) { vehicle in
                Annotation(
                    vehicle.vehicleLabel,
                    coordinate: .init(
                        latitude: vehicle.vehiclePosition.latitude,
                        longitude: vehicle.vehiclePosition.longitude
                    )
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.background)
                            .stroke(.secondary, lineWidth: 4)

                        Image(systemName: "bus.fill")
                            .padding(4)
                    }
                }
            }
        }
        .overlay {
            if presenter.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
            }
        }
        .task {
            await presenter.startFetchingVehiclePositions()
        }
    }
}

#Preview {
    MapView(presenter: .constant(GTFSRealtimePresenter()))
}
