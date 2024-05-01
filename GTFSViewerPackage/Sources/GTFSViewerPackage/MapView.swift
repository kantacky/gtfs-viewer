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
                    ),
                    anchor: .center
                ) {
                    Button {
                        presenter.selectedVehicle = vehicle
                    } label: {
                        Circle()
                            .fill(Color.red)
                    }
                }
            }

            if let vehicle = presenter.selectedVehicle {
                Annotation(
                    vehicle.vehicleLabel,
                    coordinate: .init(
                        latitude: vehicle.vehiclePosition.latitude,
                        longitude: vehicle.vehiclePosition.longitude
                    ),
                    anchor: .bottom
                ) {
                    VStack(spacing: .zero) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(vehicle.vehicleLabel): (\(Float(vehicle.vehiclePosition.latitude)), \(Float(vehicle.vehiclePosition.longitude)))")
                            Button {
                                Task { await presenter.watchVehiclePosition(vehicle) }
                            } label: {
                                Label("Watch this Vehicle", systemImage: "eye")
                                    .bold()
                                    .padding(
                                        EdgeInsets(
                                            top: 4,
                                            leading: 8,
                                            bottom: 4,
                                            trailing: 8
                                        )
                                    )
                                    .foregroundStyle(Color.white)
                                    .background(Color.accentColor)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 4)

                        Path { path in
                            let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
                            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                            path.closeSubpath()
                        }
                        .fill(.background)
                        .frame(width: 24, height: 24)
                    }
                    .padding()
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
