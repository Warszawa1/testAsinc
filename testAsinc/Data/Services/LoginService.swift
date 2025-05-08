//
//  LoginService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

protocol LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}

class LoginService: LoginServiceProtocol {
    private let apiProvider: ApiProvider
    private let secureDataService: SecureDataService
    
    init(apiProvider: ApiProvider = ApiProvider(),
         secureDataService: SecureDataService = SecureDataService.shared) {
        self.apiProvider = apiProvider
        self.secureDataService = secureDataService
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        apiProvider.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                // Save the token
                self?.secureDataService.setToken(token)
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
