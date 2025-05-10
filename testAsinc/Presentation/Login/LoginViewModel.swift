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
    
    // MARK: - Setup
    private func setupBindings() {
        loginTrigger
            .flatMap { [weak self] _ -> AnyPublisher<LoginState, Never> in
                guard let self = self else {
                    return Just(.error(message: "Internal error")).eraseToAnyPublisher()
                }
                
                // Validate inputs
                guard !self.email.isEmpty else {
                    return Just(.error(message: "login.error.emptyEmail".localized)).eraseToAnyPublisher()
                }
                
                guard !self.password.isEmpty else {
                    return Just(.error(message: "login.error.emptyPassword".localized)).eraseToAnyPublisher()
                }
                
                // Create a future that handles the async login
                return Future<LoginState, Never> { promise in
                    Task {
                        do {
                            try await self.authRepository.login(email: self.email, password: self.password)
                            promise(.success(.success))
                        } catch {
                            promise(.success(.error(message: error.localizedDescription)))
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
