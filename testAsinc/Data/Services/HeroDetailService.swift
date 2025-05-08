//
//  HeroDetailService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

protocol HeroDetailServiceProtocol {
    func getHeroLocations(heroId: String, completion: @escaping (Result<[HeroLocation], Error>) -> Void)
}

class HeroDetailService: HeroDetailServiceProtocol {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func getHeroLocations(heroId: String, completion: @escaping (Result<[HeroLocation], Error>) -> Void) {
        apiProvider.getLocations(forHeroId: heroId) { result in
            switch result {
            case .success(let apiLocations):
                // Convert API models to domain models
                let locations = apiLocations.map { apiLocation in
                    HeroLocation(
                        id: apiLocation.id,
                        longitude: apiLocation.longitude,
                        latitude: apiLocation.latitude,
                        date: apiLocation.date,
                        hero: nil // We don't need the hero reference here
                    )
                }
                completion(.success(locations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
