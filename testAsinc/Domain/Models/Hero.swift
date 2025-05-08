//
//  Hero.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

struct Hero: Hashable, Identifiable {
    let id: String
    var favorite: Bool?
    let name: String?
    let description: String?
    let photo: String?
    
    // Conform to Identifiable protocol
    var identifier: String { id }
}
