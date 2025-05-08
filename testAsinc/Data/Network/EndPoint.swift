//
//  EndPoint.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

enum Endpoint {
    case login
    case heroes
    case heroLocations(String)
    case heroTransformations(String)
    
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .heroes:
            return "/api/heros/all"
        case .heroLocations:
            return "/api/heros/locations"
        case .heroTransformations:
            return "/api/heros/tranformations"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .login, .heroes, .heroLocations, .heroTransformations:
            return .post
        }
    }
    
    var requiresAuthentication: Bool {
        switch self {
        case .login:
            return false
        case .heroes, .heroLocations, .heroTransformations:
            return true
        }
    }
}
