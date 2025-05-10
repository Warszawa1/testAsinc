//
//  HeroRepositoryProtocol.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//
import Foundation
import Combine

protocol HeroRepositoryProtocol {
    func getHeroes() async throws -> [Hero]
    func getHeroTransformations(heroId: String) async throws -> [Transformation]
}

final class HeroRepository: HeroRepositoryProtocol {
    private let heroesService: HeroesServiceProtocol
    private let heroDetailService: HeroDetailServiceProtocol
    
    init(heroesService: HeroesServiceProtocol = HeroesService(),
         heroDetailService: HeroDetailServiceProtocol = HeroDetailService()) {
        self.heroesService = heroesService
        self.heroDetailService = heroDetailService
    }
    
    func getHeroes() async throws -> [Hero] {
        return try await heroesService.getHeroes()
    }
    
    func getHeroTransformations(heroId: String) async throws -> [Transformation] {
        return try await heroDetailService.getHeroTransformations(heroId: heroId)
    }
}
