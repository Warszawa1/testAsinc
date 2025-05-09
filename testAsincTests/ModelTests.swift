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


func testTransformation_initialization() {
    // Given/When
    let transformation = Transformation(id: "1", name: "Super Saiyan", description: "First form", photo: "url")
    
    // Then
    XCTAssertEqual(transformation.id, "1")
    XCTAssertEqual(transformation.name, "Super Saiyan")
    XCTAssertEqual(transformation.description, "First form")
    XCTAssertEqual(transformation.photo, "url")
}
