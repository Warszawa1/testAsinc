//
//  HeroDetailService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

protocol HeroDetailServiceProtocol {
    func getHeroTransformations(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

class HeroDetailService: HeroDetailServiceProtocol {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func getHeroTransformations(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        apiProvider.getTransformations(forHeroId: heroId) { result in
            switch result {
            case .success(let apiTransformations):
                let transformations = apiTransformations.map { apiTransformation in
                    Transformation(
                        id: apiTransformation.id,
                        name: apiTransformation.name,
                        description: apiTransformation.description,
                        photo: apiTransformation.photo
                    )
                }
                completion(.success(transformations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
