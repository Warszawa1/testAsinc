//
//  ViewModelTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//


import XCTest
import Combine
@testable import testAsinc

class ViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testHero_properties() {
        // Given
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test", photo: "url")
        
        // Then
        XCTAssertEqual(hero.id, "1")
        XCTAssertEqual(hero.name, "Goku")
        XCTAssertEqual(hero.favorite, true)
    }

    func testTransformation_properties() {
        // Given
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test", photo: nil)
        
        // Then
        XCTAssertEqual(transformation.id, "1")
        XCTAssertEqual(transformation.name, "Super Saiyan")
    }

    func testHeroCell_initialization() {
        // Given
        let cell = HeroCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Then
        XCTAssertNotNil(cell)
    }

    func testTransformationCell_initialization() {
        // Given/When
        let cell = TransformationCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Then
        XCTAssertNotNil(cell)
    }

    func testHeroesViewController_initialization() {
        // Given/When
        let viewController = HeroesViewController()
        
        // Then
        XCTAssertNotNil(viewController)
    }

    func testLoginViewController_initialization() {
        // Given/When
        let viewController = LoginViewController()
        
        // Then
        XCTAssertNotNil(viewController)
    }

    func testHeroDetailViewController_initialization() {
        // Given
        let hero = Hero(id: "1", favorite: false, name: "Goku", description: "Test", photo: nil)
        let viewModel = HeroDetailViewModel(hero: hero)
        
        // When
        let viewController = HeroDetailViewController(viewModel: viewModel)
        
        // Then
        XCTAssertNotNil(viewController)
    }

    func testString_localization() {
        // Given
        let key = "common.ok"
        
        // When
        let localized = key.localized
        
        // Then
        XCTAssertNotEqual(localized, key, "Localization should return a different string than the key")
    }
}
