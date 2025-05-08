//
//  testAsincTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 8/5/25.
//

import XCTest
import Combine
@testable import testAsinc

class testAsincTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
    }
    
    // MARK: - LoginViewModel Tests (if you have LoginViewModel)
    
    func testLoginViewModel_validCredentials() {
        // Given
        let mockService = MockLoginService()
        let viewModel = LoginViewModel(authRepository: MockAuthRepository())
        let expectation = XCTestExpectation(description: "Login successful")
        
        viewModel.email = "test@test.com"
        viewModel.password = "password"
        
        // When/Then
        viewModel.$state
            .sink { state in
                if case .success = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loginTrigger.send()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoginViewModel_emptyEmail() {
        // Given
        let mockService = MockLoginService()
        let viewModel = LoginViewModel(authRepository: MockAuthRepository())
        
        viewModel.email = ""
        viewModel.password = "password"
        
        // When
        viewModel.loginTrigger.send()
        
        // Then - wait a bit for the async operation to complete
        let expectation = XCTestExpectation(description: "State should be error")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("DEBUG: Current state is \(viewModel.state)")
            if case .error(let message) = viewModel.state {
                print("DEBUG: Error message is: '\(message)'")
                XCTAssert(message.contains("email") || message.contains("Email"), "Expected error message about email but got: \(message)")
                expectation.fulfill()
            } else {
                XCTFail("Expected error state but got: \(viewModel.state)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - HeroesViewModel Tests (adjust based on your existing implementation)
    
    func testHeroesViewModel_loadHeroes() {
        // Given
        let mockRepository = MockHeroRepository()
        let authRepository = MockAuthRepository()
        let viewModel = HeroesViewModel(heroRepository: mockRepository, authRepository: authRepository)
        let expectation = XCTestExpectation(description: "Heroes loaded")
        
        // When/Then
        viewModel.$state
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadHeroes()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.heroes.isEmpty)
    }
    
    // MARK: - HeroDetailViewModel Tests
    
    func testHeroDetailViewModel_loadTransformations() {
        // Given
        let hero = Hero(id: "1", favorite: false, name: "Goku", description: "Test", photo: nil)
        let mockService = MockHeroDetailService()
        let viewModel = HeroDetailViewModel(hero: hero, heroDetailService: mockService)
        let expectation = XCTestExpectation(description: "Transformations loaded")
        
        // When/Then
        viewModel.$state
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.transformations.isEmpty)
    }
    
    // MARK: - HeroDetailService Tests
    
    func testHeroDetailService_fetchTransformations() {
        // Given
        let service = HeroDetailService(apiProvider: MockApiProvider())
        let expectation = XCTestExpectation(description: "Transformations fetched")
        let heroId = "test-hero-id"
        
        // When
        service.getHeroTransformations(heroId: heroId) { result in
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
    
    // MARK: - Model Tests
    
    func testHero_initialization() {
        // Given/When
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test", photo: nil)
        
        // Then
        XCTAssertEqual(hero.id, "1")
        XCTAssertEqual(hero.name, "Goku")
        XCTAssertEqual(hero.favorite, true)
        XCTAssertNil(hero.photo)
    }
    
    func testTransformation_initialization() {
        // Given/When
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test", photo: nil)
        
        // Then
        XCTAssertEqual(transformation.id, "1")
        XCTAssertEqual(transformation.name, "Super Saiyan")
        XCTAssertNotNil(transformation.identifier)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationFlow() {
        // Test that ViewControllers can be initialized correctly
        let hero = Hero(id: "1", favorite: false, name: "Goku", description: "Test", photo: nil)
        
        // These should not crash
        let splashVC = SplashViewController()
        XCTAssertNotNil(splashVC)
        
        let loginVC = LoginViewController()
        XCTAssertNotNil(loginVC)
        
        let heroesVC = HeroesViewController()
        XCTAssertNotNil(heroesVC)
        
        let heroDetailViewModel = HeroDetailViewModel(hero: hero)
        let heroDetailVC = HeroDetailViewController(viewModel: heroDetailViewModel)
        XCTAssertNotNil(heroDetailVC)
        
        let transformation = Transformation(id: "1", name: "Test", description: nil, photo: nil)
        let transformationVC = TransformationDetailViewController(transformation: transformation)
        XCTAssertNotNil(transformationVC)
    }
}

// MARK: - Mock Classes

class MockLoginService: LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if email == "test@test.com" && password == "password" {
            completion(.success("mock-token"))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: nil)))
        }
    }
}

class MockHeroRepository: HeroRepositoryProtocol {
    func getHeroes() -> AnyPublisher<[Hero], Error> {
        let heroes = [
            Hero(id: "1", favorite: false, name: "Goku", description: "Saiyan warrior", photo: nil),
            Hero(id: "2", favorite: true, name: "Vegeta", description: "Prince of Saiyans", photo: nil)
        ]
        return Just(heroes)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error> {
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "First transformation", photo: nil)
        ]
        return Just(transformations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockAuthRepository: AuthRepositoryProtocol {
    var logoutCalled = false
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func logout() {
        logoutCalled = true
    }
    
    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        return Just(true).eraseToAnyPublisher()
    }
}

class MockSecureDataService: SecureDataServiceProtocol {
    private var token: String?
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    
    func getToken() -> String? {
        return token
    }
    
    func setToken(_ token: String) {
        self.token = token
        tokenSubject.send(token)
    }
    
    func clearToken() {
        self.token = nil
        tokenSubject.send(nil)
    }
    
    var tokenPublisher: AnyPublisher<String?, Never> {
        return tokenSubject.eraseToAnyPublisher()
    }
}

class MockHeroDetailService: HeroDetailServiceProtocol {
    func getHeroTransformations(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: nil)
        ]
        completion(.success(transformations))
    }
}

class MockApiProvider: ApiProvider {
    override func getTransformations(forHeroId heroId: String, completion: @escaping (Result<[ApiTransformation], Error>) -> Void) {
        let apiTransformations = [
            ApiTransformation(id: "1", name: "Super Saiyan", description: "Test", photo: nil, hero: ApiTransformation.ApiHeroReference(id: heroId))
        ]
        completion(.success(apiTransformations))
    }
}
