//
//  MockHeroesService.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

class MockHeroesService: HeroesServiceProtocol {
    func getHeroes(completion: @escaping (Result<[Hero], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Create mock heroes
            let heroes = [
                Hero(id: "1", favorite: true, name: "Goku", description: "The main protagonist", photo: nil),
                Hero(id: "2", favorite: false, name: "Vegeta", description: "The prince of all Saiyans", photo: nil),
                Hero(id: "3", favorite: true, name: "Piccolo", description: "A Namekian warrior", photo: nil),
                Hero(id: "4", favorite: false, name: "Gohan", description: "Goku's son", photo: nil),
                Hero(id: "5", favorite: true, name: "Trunks", description: "Vegeta's son from the future", photo: nil),
                Hero(id: "6", favorite: false, name: "Frieza", description: "A powerful villain", photo: nil)
            ]
            
            completion(.success(heroes))
        }
    }
}
