//
//  VehicleControllerView.swift
//
//
//  Created by Kanta Oikawa on 2024/05/01.
//

import SwiftUI

struct VehicleControllerView: View {
    @Bindable private var presenter: VehicleControllerPresenter

    init(presenter: VehicleControllerPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        Form {
            Section {
                Text(presenter.agencyID.uuidString)
                    .lineLimit(1)
            } header: {
                Label("Agency", systemImage: "building.2")
            }

            Section {
                Text(presenter.vehicleID)
                    .lineLimit(1)
                Button("Back to Agency Mode") {
                    Task { await presenter.back() }
                }
            } header: {
                Label("Vehicle", systemImage: "bus")
            }

            Section {
                DatePicker("Date", selection: $presenter.timestampFrom, displayedComponents: [.date])
                DatePicker("Time", selection: $presenter.timestampFrom, displayedComponents: [.hourAndMinute])
            } header: {
                Label("From", systemImage: "clock")
            }

            Section {
                DatePicker("Date", selection: $presenter.timestampTo, displayedComponents: [.date])
                DatePicker("Time", selection: $presenter.timestampTo, displayedComponents: [.hourAndMinute])
            } header: {
                Label("To", systemImage: "clock")
            }
        }
        .onChange(of: presenter.timestampFrom) { _, _ in
            Task {
                await presenter.fetch()
            }
        }
        .onChange(of: presenter.timestampTo) { _, _ in
            Task {
                await presenter.fetch()
            }
        }
    }
}

#Preview {
    VehicleControllerView(
        presenter: .init(
            agencyID: UUID(0),
            vehicleID: "",
            back: {},
            fetch: {}
        )
    )
}
