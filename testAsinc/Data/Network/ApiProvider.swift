//
//  ApiProvider.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

class ApiProvider {
    private let baseURL = "https://dragonball.keepcoding.education"
    private let secureDataService: SecureDataService
    var session: URLSession = .shared
    
    init(secureDataService: SecureDataService = SecureDataService.shared) {
        self.secureDataService = secureDataService
    }
    
    // Login functionality
    func login(email: String, password: String) async throws -> String {
        // Create login string for Basic auth
        let loginString = String(format: "%@:%@", email, password)
        guard let loginData = loginString.data(using: .utf8) else {
            throw NetworkError.invalidData
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        // Create request
        guard let url = URL(string: "\(baseURL)/api/auth/login") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Execute request
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            guard let token = String(data: data, encoding: .utf8) else {
                throw NetworkError.invalidData
            }
            return token
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
    
    // Get heroes
    func getHeroes() async throws -> [ApiHero] {
        return try await performRequest(endpoint: .heroes, body: ["name": ""])
    }
    
    // Get hero locations
    func getLocations(forHeroId heroId: String) async throws -> [ApiHeroLocation] {
        return try await performRequest(endpoint: .heroLocations(heroId), body: ["id": heroId])
    }
    
    // Get hero transformations
    func getTransformations(forHeroId heroId: String) async throws -> [ApiTransformation] {
        return try await performRequest(endpoint: .heroTransformations(heroId), body: ["id": heroId])
    }
    
    // Generic request method
    private func performRequest<T: Decodable>(endpoint: Endpoint, body: [String: Any]) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication if required
        if endpoint.requiresAuthentication {
            guard let token = secureDataService.getToken() else {
                throw NetworkError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Execute request
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                return decodedObject
            } catch {
                throw NetworkError.decodingError
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
}
