//
//  NetworkTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc


class NetworkTests: XCTestCase {
    
    func testEndpoint_paths() {
        // Test all endpoint paths
        XCTAssertEqual(Endpoint.login.path, "/api/auth/login")
        XCTAssertEqual(Endpoint.heroes.path, "/api/heros/all")
        XCTAssertEqual(Endpoint.heroLocations("123").path, "/api/heros/locations")
        XCTAssertEqual(Endpoint.heroTransformations("123").path, "/api/heros/tranformations")
    }
    
    func testEndpoint_methods() {
        // Test HTTP methods
        XCTAssertEqual(Endpoint.login.method, .post)
        XCTAssertEqual(Endpoint.heroes.method, .post)
        XCTAssertEqual(Endpoint.heroLocations("123").method, .post)
        XCTAssertEqual(Endpoint.heroTransformations("123").method, .post)
    }
    
    func testEndpoint_authentication() {
        // Test authentication requirements
        XCTAssertFalse(Endpoint.login.requiresAuthentication)
        XCTAssertTrue(Endpoint.heroes.requiresAuthentication)
        XCTAssertTrue(Endpoint.heroLocations("123").requiresAuthentication)
        XCTAssertTrue(Endpoint.heroTransformations("123").requiresAuthentication)
    }
    
    func testNetworkError_localizedDescriptions() {
        // Test error descriptions
        XCTAssertNotNil(NetworkError.invalidURL.errorDescription)
        XCTAssertNotNil(NetworkError.noResponse.errorDescription)
        XCTAssertNotNil(NetworkError.unauthorized.errorDescription)
        XCTAssertNotNil(NetworkError.invalidResponse.errorDescription)
        XCTAssertNotNil(NetworkError.unexpectedStatusCode(404).errorDescription)
        XCTAssertNotNil(NetworkError.invalidData.errorDescription)
        XCTAssertNotNil(NetworkError.decodingError.errorDescription)
        XCTAssertNotNil(NetworkError.serverError(500).errorDescription)
        XCTAssertNotNil(NetworkError.noData.errorDescription)
    }
    
    func testAppError_localizedDescriptions() {
        // Test app error descriptions
        XCTAssertNotNil(AppError.networkError(NSError(domain: "", code: 0)).localizedDescription)
        XCTAssertNotNil(AppError.decodingError.localizedDescription)
        XCTAssertNotNil(AppError.invalidURL.localizedDescription)
        XCTAssertNotNil(AppError.noData.localizedDescription)
        XCTAssertNotNil(AppError.unauthorized.localizedDescription)
        XCTAssertNotNil(AppError.unexpectedStatusCode.localizedDescription)
        XCTAssertNotNil(AppError.invalidToken.localizedDescription)
        XCTAssertNotNil(AppError.databaseError("Test error").localizedDescription)
    }
}
