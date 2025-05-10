//
//  SecureDataService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import KeychainSwift
import Combine

protocol SecureDataServiceProtocol {
    func getToken() -> String?
    func setToken(_ token: String)
    func clearToken()
    var tokenPublisher: AnyPublisher<String?, Never> { get }
}

final class SecureDataService: SecureDataServiceProtocol {
    // Singleton instance
    static let shared = SecureDataService()
    
    // Constants
    private let tokenKey = "auth_token"
    
    // Properties
    private let keychain = KeychainSwift()
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    
    // Publishers
    var tokenPublisher: AnyPublisher<String?, Never> {
        tokenSubject.eraseToAnyPublisher()
    }
    
    // Initialization
    private init() {
        let token = keychain.get(tokenKey)
        tokenSubject.send(token)
    }
    
    // MARK: - Public Methods
    func getToken() -> String? {
        let token = keychain.get(tokenKey)
        
        // Validate token before returning
        if let token = token, isValidToken(token) {
            return token
        } else {
            // Clear invalid token
            if token != nil {
                clearToken()
            }
            return nil
        }
    }
    
    private func isValidToken(_ token: String) -> Bool {
        // Basic validation
        let trimmedToken = token.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedToken.isEmpty && trimmedToken.count > 10
    }
    
    func setToken(_ token: String) {
        // Only set valid tokens
        if isValidToken(token) {
            keychain.set(token, forKey: tokenKey)
            tokenSubject.send(token)
        }
    }
    
    func clearToken() {
        keychain.delete(tokenKey)
        tokenSubject.send(nil)
    }
}
