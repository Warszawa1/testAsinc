//
//  SplashViewModel.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

class SplashViewModel {
    @Published private(set) var shouldNavigateToLogin = false
    @Published private(set) var shouldNavigateToHeroes = false
    
    private let authRepository: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func checkAuthenticationStatus() {
        // Add a small delay for splash screen effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            if SecureDataService.shared.getToken() != nil {
                self?.shouldNavigateToHeroes = true
            } else {
                self?.shouldNavigateToLogin = true
            }
        }
    }
}
