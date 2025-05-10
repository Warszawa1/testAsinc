//
//  AuthRepository.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws
    func logout()
    var isLoggedInPublisher: AnyPublisher<Bool, Never> { get }
}

final class AuthRepository: AuthRepositoryProtocol {
    private let loginService: LoginServiceProtocol
    private let secureDataService: SecureDataServiceProtocol
    
    init(loginService: LoginServiceProtocol = LoginService(),
         secureDataService: SecureDataServiceProtocol = SecureDataService.shared) {
        self.loginService = loginService
        self.secureDataService = secureDataService
    }
    
    func login(email: String, password: String) async throws {
        _ = try await loginService.login(email: email, password: password)
    }
    
    func logout() {
        secureDataService.clearToken()
    }
    
    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        secureDataService.tokenPublisher
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
}
