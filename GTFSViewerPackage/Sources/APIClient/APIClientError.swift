//
//  APIClientError.swift
//
//
//  Created by Kanta Oikawa on 2024/04/25.
//

import Foundation

public enum APIClientError: LocalizedError {
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response."
        }
    }
}
