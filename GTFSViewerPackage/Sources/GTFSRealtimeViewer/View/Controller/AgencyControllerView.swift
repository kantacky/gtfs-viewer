//
//  AgencyControllerView.swift
//
//
//  Created by Kanta Oikawa on 2024/05/01.
//

import SwiftUI

struct AgencyControllerView: View {
    @Bindable private var presenter: AgencyControllerPresenter

    init(presenter: AgencyControllerPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        Form {
            Section {
                LabeledContent("Agency", value: presenter.agencyID.uuidString)
                    .lineLimit(1)
            } header: {
                Label("Map View Mode", systemImage: "eye")
            }

            Section {
                Toggle("Track Now", isOn: $presenter.isTrackingNow)
                if !presenter.isTrackingNow {
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
        .onChange(of: presenter.timestamp) { _, _ in
            Task {
                await presenter.fetch()
            }
        }
        .onChange(of: presenter.bufferSeconds) { _, _ in
            Task {
                await presenter.fetch()
            }
        }
    }
}

#Preview {
    AgencyControllerView(
        presenter: .init(agencyID: UUID(0)) {}
    )
}
