//
//  VehicleAnnotationDetailView.swift
//
//
//  Created by Kanta Oikawa on 2024/05/02.
//

import GTFSViewerEntity
import SwiftUI

struct VehicleAnnotationDetailView: View {
    private let vehiclePosition: VehiclePosition
    private let watchAction: () -> Void
    private let closeAction: () -> Void

    init(
        vehiclePosition: VehiclePosition,
        watchAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) {
        self.vehiclePosition = vehiclePosition
        self.watchAction = watchAction
        self.closeAction = closeAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("\(vehiclePosition.vehicleLabel)")
                    .font(.title)
                    .bold()

                Spacer()

                HStack {
                    Button(action: watchAction) {
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

                    Button(action: closeAction) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                }
            }
            Text(DateFormatter.iso8601.string(from: vehiclePosition.timestamp))
            Text("(\(Float(vehiclePosition.vehiclePosition.latitude)), \(Float(vehiclePosition.vehiclePosition.longitude)))")
            Text("Trip ID: \(vehiclePosition.tripID)")
            Text("Route ID: \(vehiclePosition.routeID)")
            Text("Direction ID: \(vehiclePosition.directionID)")
            Text("Start: \(DateFormatter.iso8601.string(from: vehiclePosition.startDatetime))")
            Text("Schedule Relationship: \(vehiclePosition.scheduleRelationship)")
            Text("Current Stop Sequence: \(vehiclePosition.currentStopSequence)")
            Text("Stop ID: \(vehiclePosition.stopID)")
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
    }
}

#if DEBUG
#Preview {
    VehicleAnnotationDetailView(vehiclePosition: .mock1, watchAction: {}, closeAction: {})
}
#endif
