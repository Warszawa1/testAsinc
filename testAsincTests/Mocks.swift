//
//  Mocks.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc


class MockLoginService: LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if email == "test@test.com" && password == "password" {
                completion(.success("mock-token"))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
            }
        }
    }
}

class MockHeroesService: HeroesServiceProtocol {
    func getHeroes(completion: @escaping (Result<[Hero], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Create mock heroes
            let heroes = [
                Hero(id: "1", favorite: true, name: "Goku", description: "The main protagonist", photo: nil),
                Hero(id: "2", favorite: false, name: "Vegeta", description: "The prince of all Saiyans", photo: nil),
                Hero(id: "3", favorite: true, name: "Piccolo", description: "A Namekian warrior", photo: nil),
                Hero(id: "4", favorite: false, name: "Gohan", description: "Goku's son", photo: nil),
                Hero(id: "5", favorite: true, name: "Trunks", description: "Vegeta's son from the future", photo: nil),
                Hero(id: "6", favorite: false, name: "Frieza", description: "A powerful villain", photo: nil)
            ]
            
            completion(.success(heroes))
        }
    }
}

class MockHeroDetailService: HeroDetailServiceProtocol {
    func getHeroTransformations(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let transformations = [
                Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: nil)
            ]
            completion(.success(transformations))
        }
    }
}

class MockApiProvider: ApiProvider {
    // Use the real SecureDataService
    override init(secureDataService: SecureDataService = SecureDataService.shared) {
        super.init(secureDataService: secureDataService)
    }
    
    // Override methods for testing
    override func getTransformations(forHeroId heroId: String, completion: @escaping (Result<[ApiTransformation], Error>) -> Void) {
        // Mock implementation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let apiTransformations = [
                ApiTransformation(id: "1", name: "Super Saiyan", description: "First form", photo: nil, hero: ApiTransformation.ApiHeroReference(id: heroId))
            ]
            completion(.success(apiTransformations))
        }
    }
}

class MockHeroRepository: HeroRepositoryProtocol {
    func getHeroes() -> AnyPublisher<[Hero], Error> {
        let heroes = [
            Hero(id: "1", favorite: true, name: "Goku", description: "Saiyan warrior", photo: nil),
            Hero(id: "2", favorite: false, name: "Vegeta", description: "Prince of Saiyans", photo: nil)
        ]
        
        return Just(heroes)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error> {
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: nil)
        ]
        
        return Just(transformations)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

class MockAuthRepository: AuthRepositoryProtocol {
    var logoutCalled = false
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        if email.isEmpty {
            return Fail(error: NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty"]))
                .eraseToAnyPublisher()
        }
        
        if password.isEmpty {
            return Fail(error: NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password cannot be empty"]))
                .eraseToAnyPublisher()
        }
        
        return Just(())
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
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
