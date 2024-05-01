//
//  APIClient.swift
//
//
//  Created by Kanta Oikawa on 2024/04/24.
//

import Connect
import Dependencies
import DependenciesMacros
import Foundation
import GTFSViewerEntity
import KantackyAPIs

@DependencyClient
public struct APIClient: Sendable {
    public var listVehiclesPositions: @Sendable (_ agencyID: UUID, _ timestamp: Date, _ bufferSeconds: Int) async throws -> [VehiclePosition]
    public var listVehiclePositions: @Sendable (_ agencyID: UUID, _ vehicleID: String, _ timestampFrom: Date, _ timestampTo: Date) async throws -> [VehiclePosition]
}

extension APIClient: DependencyKey {
    public static let liveValue: APIClient = {
        let client = Research_GtfsRealtime_V1_GtfsrealtimeServiceClient(
            client: ProtocolClient(
                httpClient: URLSessionHTTPClient(),
                config: ProtocolClientConfig(
                    host: "https://gtfs-realtime-api-47e2p4x5ta-an.a.run.app",
                    networkProtocol: .connect,
                    codec: ProtoCodec(),
                    interceptors: []
                )
            )
        )

        return APIClient(
            listVehiclesPositions: { agencyID, timestamp, bufferSeconds in
                let request = Research_GtfsRealtime_V1_ListVehiclesPositionsRequest.with {
                    $0.agencyID = agencyID.uuidString
                    $0.timestamp = .init(date: timestamp)
                    $0.bufferSeconds = Int64(bufferSeconds)
                }

                let response = await client.listVehiclesPositions(request: request)
                guard let message = response.message else {
                    throw APIClientError.invalidResponse
                }

                return message.vehiclePositions.map {
                    VehiclePosition(
                        id: UUID(uuidString: $0.id) ?? UUID(),
                        tripID: $0.tripID,
                        routeID: $0.routeID,
                        directionID: Int($0.directionID),
                        startDatetime: $0.startDatetime.date,
                        scheduleRelationship: $0.scheduleRelationship,
                        vehicleID: $0.vehicleID,
                        vehicleLabel: $0.vehicleLabel,
                        vehiclePosition: .init(
                            latitude: Double($0.vehiclePosition.latitude),
                            longitude: Double($0.vehiclePosition.longitude)
                        ),
                        currentStopSequence: Int($0.currentStopSequence),
                        stopID: $0.stopID,
                        timestamp: $0.timestamp.date
                    )
                }
            },
            listVehiclePositions: { agencyID, vehicleID, timestampFrom, timestampTo in
                let request = Research_GtfsRealtime_V1_ListVehiclePositionsRequest.with {
                    $0.agencyID = agencyID.uuidString
                    $0.vehicleID = vehicleID
                    $0.timestampFrom = .init(date: timestampFrom)
                    $0.timestampTo = .init(date: timestampTo)
                }

                let response = await client.listVehiclePositions(request: request)
                guard let message = response.message else {
                    throw APIClientError.invalidResponse
                }

                return message.vehiclePositions.map {
                    VehiclePosition(
                        id: UUID(uuidString: $0.id) ?? UUID(),
                        tripID: $0.tripID,
                        routeID: $0.routeID,
                        directionID: Int($0.directionID),
                        startDatetime: $0.startDatetime.date,
                        scheduleRelationship: $0.scheduleRelationship,
                        vehicleID: $0.vehicleID,
                        vehicleLabel: $0.vehicleLabel,
                        vehiclePosition: .init(
                            latitude: Double($0.vehiclePosition.latitude),
                            longitude: Double($0.vehiclePosition.longitude)
                        ),
                        currentStopSequence: Int($0.currentStopSequence),
                        stopID: $0.stopID,
                        timestamp: $0.timestamp.date
                    )
                }
            }
        )
    }()
}

#if DEBUG
extension APIClient: TestDependencyKey {
    public static let testValue = APIClient(
        listVehiclesPositions: { _, _, _ in
            [.mock1, .mock2, .mock3, .mock4, .mock5]
        },
        listVehiclePositions: { _, _, _, _ in
            [.mock1, .mock2, .mock3, .mock4, .mock5]
        }
    )

    public static let previewValue = APIClient(
        listVehiclesPositions: { _, _, _ in
            [.mock1, .mock2, .mock3, .mock4, .mock5]
        },
        listVehiclePositions: { _, _, _, _ in
            [.mock1, .mock2, .mock3, .mock4, .mock5]
        }
    )
}
#endif
