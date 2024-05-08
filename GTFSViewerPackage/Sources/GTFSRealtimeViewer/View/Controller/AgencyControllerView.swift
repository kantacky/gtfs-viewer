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
                Text(presenter.agencyID.uuidString)
                    .lineLimit(1)
            } header: {
                Label("Agency", systemImage: "building.2")
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
