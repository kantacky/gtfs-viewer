//
//  DateFormatter+.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import Foundation

public extension DateFormatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }()
}
