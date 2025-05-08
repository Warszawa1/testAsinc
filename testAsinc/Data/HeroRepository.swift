//
//  HeroRepositoryProtocol.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

protocol HeroRepositoryProtocol {
    func getHeroes() -> AnyPublisher<[Hero], Error>
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error>
}

final class HeroRepository: HeroRepositoryProtocol {
    private let heroesService: HeroesServiceProtocol
    private let heroDetailService: HeroDetailServiceProtocol
    
    init(heroesService: HeroesServiceProtocol = HeroesService(),
         heroDetailService: HeroDetailServiceProtocol = HeroDetailService()) {
        self.heroesService = heroesService
        self.heroDetailService = heroDetailService
    }
    
    func getHeroes() -> AnyPublisher<[Hero], Error> {
        return Future<[Hero], Error> { promise in
            self.heroesService.getHeroes { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
    
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error> {
        return Future<[Transformation], Error> { promise in
            self.heroDetailService.getHeroTransformations(heroId: heroId) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
}
