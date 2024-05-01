//
//  VehiclePresenter.swift
//
//
//  Created by Kanta Oikawa on 2024/05/01.
//

import Foundation
import Observation

@Observable
final class VehiclePresenter {
    let agencyID: UUID
    let vehicleID: String
    var timestampFrom: Date = .now - TimeInterval(60 * 60)
    var timestampTo: Date = .now
    let back: () async -> Void
    let fetch: () async -> Void

    init(
        agencyID: UUID,
        vehicleID: String,
        back: @escaping () async -> Void,
        fetch: @escaping () async -> Void
    ) {
        self.agencyID = agencyID
        self.vehicleID = vehicleID
        self.back = back
        self.fetch = fetch
    }
}
