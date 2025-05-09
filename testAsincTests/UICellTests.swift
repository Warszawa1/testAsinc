//
//  UICellTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Kingfisher
@testable import testAsinc

class HeroCellTests: XCTestCase {
    
    func testHeroCell_initialization() {
        // Given/When
        let cell = HeroCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testHeroCell_configure() {
        // Given
        let cell = HeroCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test", photo: nil)
        
        // When
        cell.configure(with: hero)
        
        // Then - Just make sure it doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testHeroCell_prepareForReuse() {
        // Given
        let cell = HeroCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test", photo: nil)
        cell.configure(with: hero)
        
        // When
        cell.prepareForReuse()
        
        // Then - Just make sure it doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testHeroCell_UIElements() {
        // Given
        let cell = HeroCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // When
        let imgView = cell.contentView.subviews.first { $0 is UIImageView }
        
        // Then
        XCTAssertNotNil(imgView, "Image view should exist")
        
        if let imageView = imgView as? UIImageView {
            let label = imageView.subviews.first { $0 is UILabel }
            XCTAssertNotNil(label, "Label should exist within the image view")
        }
    }
}

class TransformationCellTests: XCTestCase {
    
    func testTransformationCell_initialization() {
        // Given/When
        let cell = TransformationCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testTransformationCell_configure() {
        // Given
        let cell = TransformationCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test", photo: nil)
        
        // When
        cell.configure(with: transformation)
        
        // Then - Just make sure it doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testTransformationCell_prepareForReuse() {
        // Given
        let cell = TransformationCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test", photo: nil)
        cell.configure(with: transformation)
        
        // When
        cell.prepareForReuse()
        
        // Then - Just make sure it doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testTransformationCell_UIElements() {
        // Given
        let cell = TransformationCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // When
        let imageView = cell.contentView.subviews.first { $0 is UIImageView }
        let label = cell.contentView.subviews.first { $0 is UILabel }
        
        // Then
        XCTAssertNotNil(imageView, "Image view should exist")
        XCTAssertNotNil(label, "Label should exist")
    }
}
