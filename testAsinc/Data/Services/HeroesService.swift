//
//  HeroesService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation

protocol HeroesServiceProtocol {
    func getHeroes(completion: @escaping (Result<[Hero], Error>) -> Void)
}

class HeroesService: HeroesServiceProtocol {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func getHeroes(completion: @escaping (Result<[Hero], Error>) -> Void) {
        apiProvider.getHeroes { result in
            switch result {
            case .success(let apiHeroes):
                // Convert API models to domain models
                let heroes = apiHeroes.map { apiHero in
                    Hero(
                        id: apiHero.id,
                        favorite: apiHero.favorite,
                        name: apiHero.name,
                        description: apiHero.description,
                        photo: apiHero.photo
                    )
                }
                completion(.success(heroes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
