//
//  ApiHeroLocation.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation

struct ApiHeroLocation: Codable {
    let id: String
    let longitude: String?
    let latitude: String?
    let date: String?
    let hero: ApiHeroReference?
    
    struct ApiHeroReference: Codable {
        let id: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case longitude = "longitud"
        case latitude = "latitud"
        case date = "dateShow"
        case hero
    }
}
