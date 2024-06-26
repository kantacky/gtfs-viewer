//
//  MapView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import GTFSViewerUtility
import MapKit
import SwiftUI

struct MapView: View {
    @Bindable private var presenter: GTFSRealtimePresenter

    init(presenter: GTFSRealtimePresenter) {
        self.presenter = presenter
    }

    var body: some View {
        Map(position: $presenter.mapCameraPosition) {
            ForEach(presenter.vehiclePositions) { vehicle in
                Annotation(
                    vehicle.vehicleLabel,
                    coordinate: .init(
                        latitude: vehicle.vehiclePosition.latitude,
                        longitude: vehicle.vehiclePosition.longitude
                    ),
                    anchor: .center
                ) {
                    Button {
                        presenter.selectVehicle(vehiclePosition: vehicle)
                    } label: {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                    }
                }
            }

            if let vehicle = presenter.selectedVehicle {
                Annotation(
                    "",
                    coordinate: .init(
                        latitude: vehicle.vehiclePosition.latitude,
                        longitude: vehicle.vehiclePosition.longitude
                    ),
                    anchor: .bottom
                ) {
                    VStack(spacing: .zero) {
                        VehicleAnnotationDetailView(vehiclePosition: vehicle) {
                            Task {
                                await presenter.changeMapViewModeToVehicle(
                                    vehicleID: vehicle.vehicleID
                                )
                            }
                        } closeAction: {
                            presenter.selectedVehicle = nil
                        }

                        Path { path in
                            let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
                            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                            path.closeSubpath()
                        }
                        .fill(.background)
                        .shadow(radius: 2, x: 0, y: 4)
                        .frame(width: 24, height: 24)
                    }
                    .padding()
                    .onTapGesture {
                        presenter.selectedVehicle = nil
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
    }
}

#Preview {
    MapView(presenter: GTFSRealtimePresenter())
}
