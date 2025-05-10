//
//  LoginService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation

protocol LoginServiceProtocol {
    func login(email: String, password: String) async throws -> String
}

class LoginService: LoginServiceProtocol {
    private let apiProvider: ApiProvider
    private let secureDataService: SecureDataService
    
    init(apiProvider: ApiProvider = ApiProvider(),
         secureDataService: SecureDataService = SecureDataService.shared) {
        self.apiProvider = apiProvider
        self.secureDataService = secureDataService
    }
    
    func login(email: String, password: String) async throws -> String {
        let token = try await apiProvider.login(email: email, password: password)
        // Save the token
        secureDataService.setToken(token)
        return token
    }
}
