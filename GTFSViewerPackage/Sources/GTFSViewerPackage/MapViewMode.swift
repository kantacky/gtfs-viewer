//
//  MapViewMode.swift
//
//
//  Created by Kanta Oikawa on 2024/05/01.
//

import Foundation

enum MapViewMode {
    case agency(agencyID: UUID)
    case vehicle(agencyID: UUID, vehicleID: String)
}
