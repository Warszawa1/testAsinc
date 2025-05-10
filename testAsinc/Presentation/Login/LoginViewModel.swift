//
//  LoginViewModel.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

enum LoginState: Equatable {
    case initial
    case loading
    case success
    case error(message: String)
}

class LoginViewModel {
    // MARK: - Publishers
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var state: LoginState = .initial
    
    // MARK: - Subjects
    let loginTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - Dependencies
    private let authRepository: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
        setupBindings()
    }
    
    private func setupBindings() {
        loginTrigger
            .flatMap { [weak self] _ -> AnyPublisher<LoginState, Never> in
                guard let self = self else {
                    return Just(.error(message: "Internal error")).eraseToAnyPublisher()
                }
                
                // Simple validation for empty fields
                if self.email.isEmpty && self.password.isEmpty {
                    return Just(.error(message: "Por favor, completa todos los campos")).eraseToAnyPublisher()
                } else if self.email.isEmpty {
                    return Just(.error(message: "Por favor, introduce tu email")).eraseToAnyPublisher()
                } else if self.password.isEmpty {
                    return Just(.error(message: "Por favor, introduce tu contraseña")).eraseToAnyPublisher()
                }
                
                // Create a future that handles the async login
                return Future<LoginState, Never> { promise in
                    Task {
                        do {
                            try await self.authRepository.login(email: self.email, password: self.password)
                            promise(.success(.success))
                        } catch {
                            // Simply show wrong credentials for any login error
                            promise(.success(.error(message: "Usuario o contraseña incorrectos")))
                        }
                    }
                }
                .prepend(.loading)
                .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }

}
