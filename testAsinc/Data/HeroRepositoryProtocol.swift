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
