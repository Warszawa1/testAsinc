//
//  ModelTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc


func testHero_initialization() {
    // Given/When
    let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test description", photo: "url")
    
    // Then
    XCTAssertEqual(hero.id, "1")
    XCTAssertEqual(hero.name, "Goku")
    XCTAssertEqual(hero.description, "Test description")
    XCTAssertEqual(hero.photo, "url")
    XCTAssertEqual(hero.favorite, true)
}

func testHeroLocation_initialization() {
    // Given/When
    let hero = Hero(id: "1", favorite: false, name: "Goku", description: nil, photo: nil)
    let location = HeroLocation(id: "1", longitude: "100.0", latitude: "40.0", date: "2023-01-01", hero: hero)
    
    // Then
    XCTAssertEqual(location.id, "1")
    XCTAssertEqual(location.longitude, "100.0")
    XCTAssertEqual(location.latitude, "40.0")
    XCTAssertEqual(location.date, "2023-01-01")
    XCTAssertNotNil(location.hero)
    XCTAssertEqual(location.hero?.id, "1")
    
    // Test coordinate conversion
    XCTAssertNotNil(location.coordinate)
    XCTAssertEqual(location.coordinate?.latitude, 40.0)
    XCTAssertEqual(location.coordinate?.longitude, 100.0)
}

func testTransformation_initialization() {
    // Given/When
    let transformation = Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: "url")
    
    // Then
    XCTAssertEqual(transformation.id, "1")
    XCTAssertEqual(transformation.name, "Super Saiyan")
    XCTAssertEqual(transformation.description, "First form")
    XCTAssertEqual(transformation.photo, "url")
}
