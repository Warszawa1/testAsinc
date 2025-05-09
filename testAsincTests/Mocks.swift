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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // Reduced delay for tests
            // Accept both test credentials
            if (email == "test@example.com" || email == "test@test.com") && password == "password" {
                let mockToken = "mock-token-12345"
                SecureDataService.shared.setToken(mockToken)
                completion(.success(mockToken))
            } else {
                completion(.failure(NSError(
                    domain: "MockLoginService",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]
                )))
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

class MockKeyChainStorage {
    static let shared = MockKeyChainStorage()
    private var token: String?
    
    func getToken() -> String? {
        return token
    }
    
    func set(token: String) {
        self.token = token
    }
    
    func deleteToken() {
        token = nil
    }
}

class MockURLProtocol: URLProtocol {
    // Handler for stubbing responses
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    // For simulating errors
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Missing request handler for URLProtocol")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Not implemented
    }
    
    static func urlResponseTest(url: URL, statusCode: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}

class MockData {
    static func mockApiHeroes() -> [ApiHero] {
        return [
            ApiHero(id: "1", favorite: false, name: "Goku", description: "The main protagonist", photo: "https://example.com/goku.jpg"),
            ApiHero(id: "2", favorite: false, name: "Vegeta", description: "The prince of all Saiyans", photo: "https://example.com/vegeta.jpg"),
            ApiHero(id: "3", favorite: false, name: "Piccolo", description: "A Namekian warrior", photo: "https://example.com/piccolo.jpg"),
            ApiHero(id: "4", favorite: false, name: "Gohan", description: "Goku's son", photo: "https://example.com/gohan.jpg"),
            ApiHero(id: "5", favorite: false, name: "Trunks", description: "Vegeta's son from the future", photo: "https://example.com/trunks.jpg"),
            ApiHero(id: "6", favorite: false, name: "Frieza", description: "A powerful villain", photo: "https://example.com/frieza.jpg"),
            ApiHero(id: "7", favorite: false, name: "Cell", description: "A bio-android villain", photo: "https://example.com/cell.jpg"),
            ApiHero(id: "8", favorite: false, name: "Majin Buu", description: "A magical being of evil", photo: "https://example.com/buu.jpg"),
            ApiHero(id: "9", favorite: false, name: "Krillin", description: "Goku's best friend", photo: "https://example.com/krillin.jpg"),
            ApiHero(id: "10", favorite: false, name: "Tien", description: "A powerful human warrior", photo: "https://example.com/tien.jpg"),
            ApiHero(id: "11", favorite: false, name: "Yamcha", description: "A former desert bandit", photo: "https://example.com/yamcha.jpg"),
            ApiHero(id: "12", favorite: false, name: "Bulma", description: "A brilliant scientist", photo: "https://example.com/bulma.jpg"),
            ApiHero(id: "13", favorite: false, name: "Master Roshi", description: "The legendary martial arts master", photo: "https://example.com/roshi.jpg"),
            ApiHero(id: "14", favorite: false, name: "Android 18", description: "A cybernetically enhanced human", photo: "https://example.com/android18.jpg"),
            ApiHero(id: "15", favorite: false, name: "Beerus", description: "The God of Destruction", photo: "https://example.com/beerus.jpg")
        ]
    }
    
    static func mockApiHeroesData() throws -> Data {
        let heroes = mockApiHeroes()
        return try JSONEncoder().encode(heroes)
    }
    
    static func mockApiLocations() -> [ApiHeroLocation] {
        let heroRef = ApiHeroLocation.ApiHeroReference(id: "1")
        return [
            ApiHeroLocation(id: "L1", longitude: "10.0", latitude: "20.0", date: "2025-05-10", hero: heroRef),
            ApiHeroLocation(id: "L2", longitude: "15.0", latitude: "25.0", date: "2025-05-11", hero: heroRef)
        ]
    }
    
    static func mockApiLocationsData() throws -> Data {
        let locations = mockApiLocations()
        return try JSONEncoder().encode(locations)
    }
    
    static func mockApiTransformations() -> [ApiTransformation] {
        let heroRef = ApiTransformation.ApiHeroReference(id: "1")
        return [
            ApiTransformation(id: "T1", name: "Super Saiyan", description: "The first transformation", photo: "https://example.com/ss1.jpg", hero: heroRef),
            ApiTransformation(id: "T2", name: "Super Saiyan 2", description: "The second transformation", photo: "https://example.com/ss2.jpg", hero: heroRef),
            ApiTransformation(id: "T3", name: "Super Saiyan 3", description: "The third transformation", photo: "https://example.com/ss3.jpg", hero: heroRef),
            ApiTransformation(id: "T4", name: "Super Saiyan God", description: "The godly transformation", photo: "https://example.com/ssg.jpg", hero: heroRef),
            ApiTransformation(id: "T5", name: "Super Saiyan Blue", description: "Super Saiyan God Super Saiyan", photo: "https://example.com/ssb.jpg", hero: heroRef),
            ApiTransformation(id: "T6", name: "Ultra Instinct Sign", description: "The incomplete Ultra Instinct", photo: "https://example.com/uis.jpg", hero: heroRef),
            ApiTransformation(id: "T7", name: "Mastered Ultra Instinct", description: "The complete Ultra Instinct", photo: "https://example.com/mui.jpg", hero: heroRef),
            ApiTransformation(id: "T8", name: "Great Ape", description: "The primal Saiyan transformation", photo: "https://example.com/greatape.jpg", hero: heroRef),
            ApiTransformation(id: "T9", name: "Kaioken", description: "A technique that multiplies power", photo: "https://example.com/kaioken.jpg", hero: heroRef),
            ApiTransformation(id: "T10", name: "Golden Form", description: "Frieza's ultimate form", photo: "https://example.com/golden.jpg", hero: heroRef),
            ApiTransformation(id: "T11", name: "Perfect Form", description: "Cell's ultimate form", photo: "https://example.com/perfect.jpg", hero: heroRef),
            ApiTransformation(id: "T12", name: "Kid Buu", description: "Buu's most dangerous form", photo: "https://example.com/kidbuu.jpg", hero: heroRef),
            ApiTransformation(id: "T13", name: "Super Saiyan Rage", description: "Trunks' unique transformation", photo: "https://example.com/ssrage.jpg", hero: heroRef),
            ApiTransformation(id: "T14", name: "Mystic Form", description: "Gohan's ultimate potential", photo: "https://example.com/mystic.jpg", hero: heroRef)
        ]
    }
    
    static func mockApiTransformationsData() throws -> Data {
        let transformations = mockApiTransformations()
        return try JSONEncoder().encode(transformations)
    }
}
