//
//  ControllerView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import SwiftUI

struct ControllerView: View {
    @Bindable private var presenter: GTFSRealtimePresenter

    init(presenter: GTFSRealtimePresenter) {
        self.presenter = presenter
    }

    var body: some View {
        switch presenter.mapViewMode {
        case let .agency(presenter):
            AgencyControllerView(presenter: presenter)

        case let .vehicle(presenter):
            VehicleControllerView(presenter: presenter)
        }
    }
}

#if DEBUG
#Preview {
    ControllerView(presenter: GTFSRealtimePresenter())
}
#endif
