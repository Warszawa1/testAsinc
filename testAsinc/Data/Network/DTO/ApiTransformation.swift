//
//  ApiTransformation.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation

struct ApiTransformation: Codable {
    let id: String
    let name: String
    let description: String?
    let photo: String?
    let hero: ApiHeroReference
    
    struct ApiHeroReference: Codable {
        let id: String
    }
}
