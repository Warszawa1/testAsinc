//
//  HeroDetailService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

protocol HeroDetailServiceProtocol {
    func getHeroTransformations(heroId: String) async throws -> [Transformation]
}

class HeroDetailService: HeroDetailServiceProtocol {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func getHeroTransformations(heroId: String) async throws -> [Transformation] {
        let apiTransformations = try await apiProvider.getTransformations(forHeroId: heroId)
        
        let transformations = apiTransformations.map { apiTransformation in
            Transformation(
                id: apiTransformation.id,
                name: apiTransformation.name,
                description: apiTransformation.description,
                photo: apiTransformation.photo
            )
        }
        
        return transformations
    }
}
