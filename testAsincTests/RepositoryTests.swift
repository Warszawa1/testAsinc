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
    
    func testAuthRepository_login() {
        // Given
        let mockLoginService = MockLoginService()
        let mockSecureDataService = MockSecureDataService()
        let repository = AuthRepository(loginService: mockLoginService, secureDataService: mockSecureDataService)
        let expectation = XCTestExpectation(description: "Login successful")
        
        // When
        repository.login(email: "test@test.com", password: "password")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Login should succeed")
                }
            }, receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAuthRepository_loginFailure() {
        // Given
        let mockLoginService = MockLoginService()
        let mockSecureDataService = MockSecureDataService()
        let repository = AuthRepository(loginService: mockLoginService, secureDataService: mockSecureDataService)
        let expectation = XCTestExpectation(description: "Login failed")
        
        // When
        repository.login(email: "wrong@email.com", password: "wrong")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Login should fail")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
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
    
    func testHeroRepository_getHeroes() {
        // Given
        let mockHeroesService = MockHeroesService()
        let repository = HeroRepository(heroesService: mockHeroesService)
        let expectation = XCTestExpectation(description: "Heroes fetched")
        
        // When
        repository.getHeroes()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { heroes in
                XCTAssertFalse(heroes.isEmpty)
                XCTAssertEqual(heroes.count, 6)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testHeroRepository_getHeroTransformations() {
        // Given
        let mockHeroDetailService = MockHeroDetailService()
        let repository = HeroRepository(heroDetailService: mockHeroDetailService)
        let expectation = XCTestExpectation(description: "Transformations fetched")
        
        // When
        repository.getHeroTransformations(heroId: "1")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { transformations in
                XCTAssertFalse(transformations.isEmpty)
                XCTAssertEqual(transformations.first?.name, "Super Saiyan")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
