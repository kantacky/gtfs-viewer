//
//  AgencyPresenter.swift
//
//
//  Created by Kanta Oikawa on 2024/05/01.
//

import Foundation
import GTFSViewerUtility
import Observation

@Observable
final class AgencyPresenter {
    let agencyID: UUID
    var timestamp: Date = .now
    var bufferSeconds: Int = 300
    var isTrackingNow: Bool = true
    let fetch: () async -> Void

    var rangeStartDateString: String {
        DateFormatter.iso8601.string(from: timestamp - TimeInterval(bufferSeconds))
    }
    var rangeEndDateString: String {
        DateFormatter.iso8601.string(from: timestamp)
    }

    init(
        agencyID: UUID,
        fetch: @escaping () async -> Void
    ) {
        self.agencyID = agencyID
        self.fetch = fetch
    }
}
