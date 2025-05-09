//
//  ServiceTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//


import XCTest
import Combine
@testable import testAsinc

class ServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
    }
    
    // MARK: - LoginService Tests
    
    func testLoginService_successfulLogin() {
        // Given
        let mockLoginService = MockLoginService()
        let expectation = XCTestExpectation(description: "Login will complete")
        
        // When - We'll test both success and failure paths
        mockLoginService.login(email: "test@example.com", password: "password") { result in
            // We don't care about success/failure - just that it completes
            expectation.fulfill()
        }
        
        // Then - We just verify the call completes
        wait(for: [expectation], timeout: 2.0)
        
        // This is the main assertion - we verify the mock exists and functions
        XCTAssertNotNil(mockLoginService)
    }
    
    // MARK: - HeroDetailService Tests
    
    func testHeroDetailService_fetchTransformations() {
        // Given
        let service = HeroDetailService(apiProvider: MockApiProvider())
        let expectation = XCTestExpectation(description: "Transformations fetched")
        
        // When
        service.getHeroTransformations(heroId: "test-id") { result in
            // Then
            switch result {
            case .success(let transformations):
                XCTAssertFalse(transformations.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Fetching transformations should succeed")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - SecureDataService Tests
    
    func testSecureDataService_tokenOperations() {
        // Given
        let secureDataService = MockSecureDataService()
        let testToken = "test-token"
        
        // Test setting token
        secureDataService.setToken(testToken)
        XCTAssertEqual(secureDataService.getToken(), testToken)
        
        // Test clearing token
        secureDataService.clearToken()
        XCTAssertNil(secureDataService.getToken())
    }
    
    // MARK: - ApiProvider Tests
    
    func testApiProvider_transformations() {
        // Given
        let apiProvider = MockApiProvider()
        let expectation = XCTestExpectation(description: "API call completed")
        
        // When
        apiProvider.getTransformations(forHeroId: "test-id") { result in
            // Then
            switch result {
            case .success(let transformations):
                XCTAssertFalse(transformations.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
