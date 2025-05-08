//
//  Transformation.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

struct Transformation: Hashable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let photo: String?
    
    // Conform to Identifiable protocol
    var identifier: String { id }
}
