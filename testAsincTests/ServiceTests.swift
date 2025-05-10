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
    
    func testLoginService_successfulLogin() async throws {
        // Given
        let mockLoginService = MockLoginService()
        
        // When
        let token = try await mockLoginService.login(email: "test@example.com", password: "password")
        
        // Then
        XCTAssertNotNil(token)
    }
    
    // MARK: - HeroDetailService Tests
    
    func testHeroDetailService_fetchTransformations() async throws {
        // Given
        let service = HeroDetailService(apiProvider: MockApiProvider())
        
        // When
        let transformations = try await service.getHeroTransformations(heroId: "test-id")
        
        // Then
        XCTAssertFalse(transformations.isEmpty)
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
    
    func testApiProvider_transformations() async throws {
        // Given
        let apiProvider = MockApiProvider()
        
        // When
        let transformations = try await apiProvider.getTransformations(forHeroId: "test-id")
        
        // Then
        XCTAssertFalse(transformations.isEmpty)
    }
}
