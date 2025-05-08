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
        print("SecureDataService: initializing")
        // Initialize with current token
        let token = keychain.get(tokenKey)
        print("SecureDataService: token exists: \(token != nil)")
        tokenSubject.send(token)
    }
    
    // MARK: - Public Methods
    func getToken() -> String? {
        return keychain.get(tokenKey)
    }
    
    func setToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
        tokenSubject.send(token)
    }
    
    func clearToken() {
        keychain.delete(tokenKey)
        tokenSubject.send(nil)
    }
}
