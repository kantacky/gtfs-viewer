//
//  GTFSRealtimeView.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import SwiftUI

struct GTFSRealtimeView: View {
    @State private var presenter: GTFSRealtimePresenter

    init(presenter: GTFSRealtimePresenter) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationSplitView {
            ControllerView(presenter: $presenter)
                .navigationTitle("GTFS Realtime")
        } detail: {
            MapView(presenter: $presenter)
                .toolbar(.hidden)
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
    GTFSRealtimeView(presenter: GTFSRealtimePresenter())
}
#endif
