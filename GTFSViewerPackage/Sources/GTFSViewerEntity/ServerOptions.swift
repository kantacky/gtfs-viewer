//
//  ServerOptions.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import Foundation

public struct ServerOptions: Decodable {
    public let gtfsRealtimeAPIHost: String
    public let gtfsRealtimeAPIPort: Int

    public init(gtfsRealtimeAPIHost: String, gtfsRealtimeAPIPort: Int) {
        self.gtfsRealtimeAPIHost = gtfsRealtimeAPIHost
        self.gtfsRealtimeAPIPort = gtfsRealtimeAPIPort
    }

    public init(contentsOfFile: String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: contentsOfFile))
        self = try JSONDecoder().decode(ServerOptions.self, from: data)
    }

    enum CodingKeys: String, CodingKey {
        case gtfsRealtimeAPIHost = "GTFS_REALTIME_API_HOST"
        case gtfsRealtimeAPIPort = "GTFS_REALTIME_API_PORT"
    }
}
