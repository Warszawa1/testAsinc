//
//  AppError.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

enum AppError: Error {
    case networkError(Error)
    case decodingError
    case invalidURL
    case noData
    case unauthorized
    case unexpectedStatusCode
    case invalidToken
    case databaseError(String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to decode data"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Unauthorized access"
        case .unexpectedStatusCode:
            return "Unexpected status code"
        case .invalidToken:
            return "Invalid or expired token"
        case .databaseError(let message):
            return "Database error: \(message)"
        }
    }
}
