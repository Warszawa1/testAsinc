//
//  ApiProviderTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc

class ApiProviderTests: XCTestCase {
    
    private var sut: ApiProvider!
    private let token = "expectedToken"

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = ApiProvider(secureDataService: SecureDataService.shared)
        sut.session = session
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = nil
        SecureDataService.shared.clearToken()
        try super.tearDownWithError()
    }
    
    
    func test_login_ShouldReturnError() async throws {
        // Given
        let username = "username"
        let password = "password"
        MockURLProtocol.error = NSError(domain: "io.keepcoding", code: 401)
        
        // When/Then
        do {
            _ = try await sut.login(email: username, password: password)
            XCTFail("Expected error")
        } catch {
            // Expected error
            XCTAssertNotNil(error)
        }
    }
    
    func test_Transformations_serviceError() async throws {
        // Given
        setToken()
        MockURLProtocol.error = NSError(domain: "io.keepcoding", code: 503)
        
        // When/Then
        do {
            _ = try await sut.getTransformations(forHeroId: "idHero")
            XCTFail("expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    
    func test_getHeroes_serviceError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: "io.keepcoding", code: 503)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = ApiProvider(secureDataService: SecureDataService.shared)
        sut.session = session
        
        // Set token before making API call
        setToken()
        
        // When/Then
        do {
            _ = try await sut.getHeroes()
            XCTFail("expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    private func setToken() {
        SecureDataService.shared.setToken(self.token)
    }
}
