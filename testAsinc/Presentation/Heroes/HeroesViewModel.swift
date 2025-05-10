//
//  HeroesViewModel.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

enum HeroesState: Equatable {
    case initial
    case loading
    case loaded
    case error(message: String)
}

class HeroesViewModel {
    // MARK: - Publishers
    @Published private(set) var heroes: [Hero] = []
    @Published private(set) var state: HeroesState = .initial
    
    // MARK: - Subjects
    let refreshTrigger = PassthroughSubject<Void, Never>()
    let logoutTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - Dependencies
    private let heroRepository: HeroRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(heroRepository: HeroRepositoryProtocol = HeroRepository(),
         authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.heroRepository = heroRepository
        self.authRepository = authRepository
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Handle refresh trigger
        refreshTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state = .loading
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<[Hero], Error>, Never> in
                guard let self = self else {
                    return Just(.failure(AppError.noData)).eraseToAnyPublisher()
                }
                
                return Future<Result<[Hero], Error>, Never> { promise in
                    Task {
                        do {
                            let heroes = try await self.heroRepository.getHeroes()
                            promise(.success(.success(heroes)))
                        } catch {
                            promise(.success(.failure(error)))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    self?.state = .loaded
                case .failure(let error):
                    self?.state = .error(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        // Handle logout
        logoutTrigger
            .sink { [weak self] _ in
                self?.authRepository.logout()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func loadHeroes() {
        refreshTrigger.send()
    }
    
    func hero(at index: Int) -> Hero? {
        guard index < heroes.count else { return nil }
        return heroes[index]
    }
}
