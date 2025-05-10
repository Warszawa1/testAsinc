//
//  RepositoryTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc


class RepositoryTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - AuthRepository
    
    func testAuthRepository_login() async throws {
        // Given
        let mockLoginService = MockLoginService()
        let mockSecureDataService = MockSecureDataService()
        let repository = AuthRepository(loginService: mockLoginService, secureDataService: mockSecureDataService)
        
        // When
        try await repository.login(email: "test@test.com", password: "password")
        
        // Then - if we reach here without throwing, login succeeded
    }

    
    func testAuthRepository_loginFailure() async throws {
        // Given
        let mockLoginService = MockLoginService()
        let mockSecureDataService = MockSecureDataService()
        let repository = AuthRepository(loginService: mockLoginService, secureDataService: mockSecureDataService)
        
        // When/Then
        do {
            try await repository.login(email: "wrong@email.com", password: "wrong")
            XCTFail("Login should fail")
        } catch {
            // Expected error
            XCTAssertNotNil(error)
        }
    }
    
    func testAuthRepository_logout() {
        // Given
        let mockLoginService = MockLoginService()
        let mockSecureDataService = MockSecureDataService()
        let repository = AuthRepository(loginService: mockLoginService, secureDataService: mockSecureDataService)
        
        // Set token first
        mockSecureDataService.setToken("test-token")
        XCTAssertNotNil(mockSecureDataService.getToken())
        
        // When
        repository.logout()
        
        // Then
        XCTAssertNil(mockSecureDataService.getToken())
    }
    
    
    // MARK: - HeroRepository
    
    func testHeroRepository_getHeroes() async throws {
        // Given
        let mockHeroesService = MockHeroesService()
        let repository = HeroRepository(heroesService: mockHeroesService)
        
        // When
        let heroes = try await repository.getHeroes()
        
        // Then
        XCTAssertFalse(heroes.isEmpty)
        XCTAssertEqual(heroes.count, 6)
    }
    
    func testHeroRepository_getHeroTransformations() async throws {
        // Given
        let mockHeroDetailService = MockHeroDetailService()
        let repository = HeroRepository(heroDetailService: mockHeroDetailService)
        
        // When
        let transformations = try await repository.getHeroTransformations(heroId: "1")
        
        // Then
        XCTAssertFalse(transformations.isEmpty)
        XCTAssertEqual(transformations.first?.name, "Super Saiyan")
    }
}
