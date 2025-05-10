//
//  HeroDetailViewModel.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

enum HeroDetailState: Equatable {
    case initial
    case loading
    case loaded
    case error(message: String)
    
    static func == (lhs: HeroDetailState, rhs: HeroDetailState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.loading, .loading), (.loaded, .loaded):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

class HeroDetailViewModel {
    // MARK: - Publishers
    @Published private(set) var hero: Hero
    @Published private(set) var transformations: [Transformation] = []
    @Published private(set) var state: HeroDetailState = .initial
    
    // MARK: - Subjects
    let loadTransformationsTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - Dependencies
    private let heroDetailService: HeroDetailServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(hero: Hero, heroDetailService: HeroDetailServiceProtocol = HeroDetailService()) {
        self.hero = hero
        self.heroDetailService = heroDetailService
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Transformations binding
        loadTransformationsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state = .loading
            })
            .flatMap { [weak self] _ -> AnyPublisher<[Transformation], Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "HeroDetailViewModel", code: 0, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                
                return Future<[Transformation], Error> { promise in
                    Task {
                        do {
                            let transformations = try await self.heroDetailService.getHeroTransformations(heroId: self.hero.id)
                            promise(.success(transformations))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] transformations in
                    self?.transformations = transformations
                    self?.state = .loaded
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func loadData() {
        loadTransformationsTrigger.send()
    }
}
