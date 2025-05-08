//
//  ApiHero.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

struct ApiHero: Codable {
    let id: String
    var favorite: Bool?
    let name: String?
    let description: String?
    let photo: String?
}
