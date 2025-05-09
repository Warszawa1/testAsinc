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
    
    
    func test_login_ShouldReturnError() throws {
        // Given
        let username = "username"
        let password = "password"
        MockURLProtocol.error = NSError(domain: "io.keepcoding", code: 401)
        var error: Error?
        
        // When
        let expectation = expectation(description: "Login throw error")
        
        sut.login(email: username, password: password) { result in
            expectation.fulfill()
            switch result {
            case .success(_):
                XCTFail("Expected error")
            case .failure(let responseError):
                error = responseError
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0) // Increased timeout
        XCTAssertNotNil(error)
    }
    
    func test_getHeroes_serviceError() throws {
        // Given
        // Configure MockURLProtocol to handle requests
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
        
        var error: Error?
        let expectation = expectation(description: "Error from server")
        
        // When
        sut.getHeroes { result in
            switch result {
            case .success(_):
                XCTFail("expected error")
            case .failure(let errorServer):
                error = errorServer
                expectation.fulfill()
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(error)
    }
    
    
    func test_Transformations_serviceError() throws {
        // Given
        setToken() // Set token first
        MockURLProtocol.error = NSError(domain: "io.keepcoding", code: 503)
        var error: Error?
        
        // When
        let expectation = expectation(description: "Error from server")
        
        sut.getTransformations(forHeroId: "idHero") { result in
            switch result {
            case .success(_):
                XCTFail("expected error")
            case .failure(let errorServer):
                error = errorServer
                expectation.fulfill() // Make sure this gets called
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3.0) // Increased timeout
        XCTAssertNotNil(error)
    }
    
    private func setToken() {
        SecureDataService.shared.setToken(self.token)
    }
}
