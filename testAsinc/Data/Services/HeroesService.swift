//
//  HeroesService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation

protocol HeroesServiceProtocol {
    func getHeroes() async throws -> [Hero]
}

class HeroesService: HeroesServiceProtocol {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func getHeroes() async throws -> [Hero] {
        let apiHeroes = try await apiProvider.getHeroes()
        
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
        
        return heroes
    }
}
