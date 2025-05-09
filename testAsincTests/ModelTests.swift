//
//  ModelTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc


class ModelTests: XCTestCase {
    
    func testHero_initialization() {
        // Given/When
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test description", photo: "url")
        
        // Then
        XCTAssertEqual(hero.id, "1")
        XCTAssertEqual(hero.name, "Goku")
        XCTAssertEqual(hero.description, "Test description")
        XCTAssertEqual(hero.photo, "url")
        XCTAssertEqual(hero.favorite, true)
        XCTAssertEqual(hero.identifier, "1") // Testing the Identifiable conformance
    }
    
    func testTransformation_initialization() {
        // Given/When
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: "url")
        
        // Then
        XCTAssertEqual(transformation.id, "1")
        XCTAssertEqual(transformation.name, "Super Saiyan")
        XCTAssertEqual(transformation.description, "First form")
        XCTAssertEqual(transformation.photo, "url")
        XCTAssertEqual(transformation.identifier, "1") // Testing the Identifiable conformance
    }
    
    func testApiHero_initialization() {
        // Given/When
        let apiHero = ApiHero(id: "1", favorite: true, name: "Goku", description: "Test", photo: "url")
        
        // Then
        XCTAssertEqual(apiHero.id, "1")
        XCTAssertEqual(apiHero.favorite, true)
        XCTAssertEqual(apiHero.name, "Goku")
        XCTAssertEqual(apiHero.description, "Test")
        XCTAssertEqual(apiHero.photo, "url")
    }
    
    func testApiHeroLocation_initialization() {
        // Given/When
        let heroRef = ApiHeroLocation.ApiHeroReference(id: "1")
        let location = ApiHeroLocation(id: "1", longitude: "100.0", latitude: "40.0", date: "2023-01-01", hero: heroRef)
        
        // Then
        XCTAssertEqual(location.id, "1")
        XCTAssertEqual(location.longitude, "100.0")
        XCTAssertEqual(location.latitude, "40.0")
        XCTAssertEqual(location.date, "2023-01-01")
        XCTAssertNotNil(location.hero)
        XCTAssertEqual(location.hero?.id, "1")
    }
    
    func testApiTransformation_initialization() {
        // Given/When
        let heroRef = ApiTransformation.ApiHeroReference(id: "1")
        let transformation = ApiTransformation(id: "1", name: "Super Saiyan", description: "Test", photo: "url", hero: heroRef)
        
        // Then
        XCTAssertEqual(transformation.id, "1")
        XCTAssertEqual(transformation.name, "Super Saiyan")
        XCTAssertEqual(transformation.description, "Test")
        XCTAssertEqual(transformation.photo, "url")
        XCTAssertEqual(transformation.hero.id, "1")
    }
}
