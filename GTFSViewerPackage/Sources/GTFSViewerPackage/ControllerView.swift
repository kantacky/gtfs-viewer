//
//  ControllerView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import SwiftUI

struct ControllerView: View {
    @Binding private var presenter: GTFSRealtimePresenter

    init(presenter: Binding<GTFSRealtimePresenter>) {
        self._presenter = presenter
    }

    var body: some View {
        Form {
            Section {
                Toggle("Track Now", isOn: $presenter.isTrackingCurrentTime)
                if !presenter.isTrackingCurrentTime {
                    DatePicker("Date", selection: $presenter.timestamp, displayedComponents: [.date])
                    DatePicker("Time", selection: $presenter.timestamp, displayedComponents: [.hourAndMinute])
                }
                LabeledContent("Buffer") {
                    HStack {
                        TextField("300", value: $presenter.bufferSeconds, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("Seconds")
                    }
                }
            } header: {
                Label("Datetime", systemImage: "clock")
            } footer: {
                VStack(alignment: .leading) {
                    Text("From: \(presenter.rangeStartDateString)")
                    Text("To: \(presenter.rangeEndDateString)")
                }
            }
        }
        .onChange(of: presenter.timestamp){ _, _ in
            Task {
                await presenter.fetchVehiclePositions()
            }
        }
        .onChange(of: presenter.bufferSeconds){ _, _ in
            Task {
                await presenter.fetchVehiclePositions()
            }
        }
    }
}

#Preview {
    ControllerView(presenter: .constant(GTFSRealtimePresenter()))
}
