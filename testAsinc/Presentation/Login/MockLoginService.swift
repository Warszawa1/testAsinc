//
//  MockLoginService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

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
