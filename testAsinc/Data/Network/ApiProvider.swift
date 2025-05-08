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
    
    init(secureDataService: SecureDataService = SecureDataService.shared) {
        self.secureDataService = secureDataService
    }
    
    // Login functionality
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create login string for Basic auth
        let loginString = String(format: "%@:%@", email, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        // Create request
        guard let url = URL(string: "\(baseURL)/api/auth/login") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data, let token = String(data: data, encoding: .utf8) {
                    completion(.success(token))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
            case 401:
                completion(.failure(NetworkError.unauthorized))
            default:
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
            }
        }.resume()
    }
    
    // Get heroes
    func getHeroes(completion: @escaping (Result<[ApiHero], Error>) -> Void) {
        performRequest(endpoint: .heroes, body: ["name": ""], completion: completion)
    }
    
    // Get hero locations
    func getLocations(forHeroId heroId: String, completion: @escaping (Result<[ApiHeroLocation], Error>) -> Void) {
        performRequest(endpoint: .heroLocations(heroId), body: ["id": heroId], completion: completion)
    }
    
    // Get hero transformations
    func getTransformations(forHeroId heroId: String, completion: @escaping (Result<[ApiTransformation], Error>) -> Void) {
        performRequest(endpoint: .heroTransformations(heroId), body: ["id": heroId], completion: completion)
    }
    
    // Generic request method
    private func performRequest<T: Decodable>(endpoint: Endpoint, body: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication if required
        if endpoint.requiresAuthentication {
            guard let token = secureDataService.getToken() else {
                completion(.failure(NetworkError.unauthorized))
                return
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(NetworkError.invalidData))
            return
        }
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(NetworkError.decodingError))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            case 401:
                completion(.failure(NetworkError.unauthorized))
            default:
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
            }
        }.resume()
    }
}
