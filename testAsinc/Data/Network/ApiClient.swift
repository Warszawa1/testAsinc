//
//  ApiClient.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, body: [String: Any]?) async throws -> T
    func loginRequest(email: String, password: String) async throws -> String
}

final class APIClient: APIClientProtocol {
    private let baseURL = "https://dragonball.keepcoding.education"
    private let session: URLSession
    private let secureDataService: SecureDataServiceProtocol
    
    init(session: URLSession = .shared, secureDataService: SecureDataServiceProtocol) {
        self.session = session
        self.secureDataService = secureDataService
    }
    
    func request<T: Decodable>(endpoint: Endpoint, body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization if required
        if endpoint.requiresAuthentication {
            guard let token = secureDataService.getToken() else {
                throw NetworkError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if provided
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        // Perform the request
        let (data, response) = try await session.data(for: request)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        // Decode data
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func loginRequest(email: String, password: String) async throws -> String {
        guard let url = URL(string: baseURL + Endpoint.login.path) else {
            throw NetworkError.invalidURL
        }
        
        // Create login string for Basic authentication
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            throw NetworkError.invalidData
        }
        let base64LoginString = loginData.base64EncodedString()
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Perform request
        let (data, response) = try await session.data(for: request)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        // Convert data to token string
        guard let token = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidData
        }
        
        return token
    }
}
