//
//  heroLocation.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import Foundation
import MapKit

struct HeroLocation: Identifiable {
    let id: String
    let longitude: String?
    let latitude: String?
    let date: String?
    let hero: Hero?
    
    // Conform to Identifiable protocol
    var identifier: String { id }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let longitude, let latitude,
              let longitudeDouble = Double(longitude),
              let latitudeDouble = Double(latitude) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
    }
}
