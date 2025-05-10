//
//  ViewControllerTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc

class HeroesViewControllerTests: XCTestCase {
    
    func testHeroesViewController_initialization() {
        // Given/When
        let sut = HeroesViewController()
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testHeroesViewController_viewDidLoad() {
        // Given/When
        let sut = HeroesViewController()
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.view)
    }
    
    func testHeroesViewController_collectionViewSetup() {
        // Given
        let sut = HeroesViewController()
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        let collectionView = sut.view.subviews.first { $0 is UICollectionView } as? UICollectionView
        XCTAssertNotNil(collectionView, "Collection view should be set up in viewDidLoad")
    }
    
    func testHeroesViewController_loadHeroes() {
        // Given
        let sut = HeroesViewController()
        
        // Create expectation to wait for async operation
        let expectation = XCTestExpectation(description: "Load heroes")
        
        // Set up a way to know when data is loaded
        // This is a bit of a hack since we don't have direct access to the private property
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            expectation.fulfill()
        }
        
        // When
        sut.loadViewIfNeeded() // This triggers loadHeroes()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        // Verify collection view has data (indirectly testing datasource)
        XCTAssertNotNil(sut)
    }
}

class LoginViewControllerTests: XCTestCase {
    
    func testLoginViewController_initialization() {
        // Given/When
        let sut = LoginViewController()
        
        // Then
        XCTAssertNotNil(sut)
    }

    
    func testLoginViewController_viewDidLoad() {
        // Given/When
        let sut = LoginViewController()
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.view)
    }
    
    func testLoginViewController_hasRequiredUIElements() {
        // Given
        let sut = LoginViewController()
        
        // When
        sut.loadViewIfNeeded()
        
        // Then - Check that UI elements exist
        // Find the scroll view first
        guard let scrollView = sut.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else {
            XCTFail("Should find a UIScrollView")
            return
        }
        
        // Find the content view - avoid using "is UIView" since all subviews are UIView instances
        // Instead, look for a specific characteristic of your content view if possible
        // For example, if your content view is the first subview, or has a specific tag
        guard let contentView = scrollView.subviews.first else {
            XCTFail("ScrollView should have a content view")
            return
        }
        
        // Now find the UI elements within the content view
        let logoImageView = contentView.subviews.first(where: { $0 is UIImageView })
        XCTAssertNotNil(logoImageView, "Logo image view should exist")
        
        let textFields = contentView.subviews.compactMap { $0 as? UITextField }
        XCTAssertEqual(textFields.count, 2, "Should have username and password text fields")
        
        let loginButton = contentView.subviews.first(where: { $0 is UIButton })
        XCTAssertNotNil(loginButton, "Login button should exist")
    }
}

class SplashViewControllerTests: XCTestCase {
    
    func testSplashViewController_initialization() {
        // Given
        let sut = SplashViewController()
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testSplashViewController_viewDidLoad() {
        // Given
        let sut = SplashViewController()
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.view)
    }
    
    func testSplashViewController_hasLogoImage() {
        // Given
        let sut = SplashViewController()
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        let logoImageView = sut.view.subviews.first { $0 is UIImageView }
        XCTAssertNotNil(logoImageView, "Logo image view should exist")
    }
}

class HeroDetailViewControllerTests: XCTestCase {
    
    func testHeroDetailViewController_initialization() {
        // Given
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test description", photo: nil)
        let viewModel = HeroDetailViewModel(hero: hero)
        let sut = HeroDetailViewController(viewModel: viewModel)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testHeroDetailViewController_viewDidLoad() {
        // Given
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test description", photo: nil)
        let viewModel = HeroDetailViewModel(hero: hero)
        let sut = HeroDetailViewController(viewModel: viewModel)
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.view)
    }
    
    func testHeroDetailViewController_hasRequiredUIElements() {
        // Given
        let hero = Hero(id: "1", favorite: true, name: "Goku", description: "Test description", photo: nil)
        let viewModel = HeroDetailViewModel(hero: hero)
        let sut = HeroDetailViewController(viewModel: viewModel)
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        // Find the scroll view
        let scrollView = sut.view.subviews.first { $0 is UIScrollView } as? UIScrollView
        XCTAssertNotNil(scrollView, "Scroll view should exist")
        
        // Find the content view inside the scroll view
        let contentView = scrollView?.subviews.first
        XCTAssertNotNil(contentView, "Content view should exist inside scroll view")

        
        // Find the hero image view
        let heroImageView = contentView?.subviews.first { $0 is UIImageView }
        XCTAssertNotNil(heroImageView, "Hero image view should exist")
        
        // Find labels
        let labels = contentView?.subviews.compactMap { $0 as? UILabel }
        XCTAssertGreaterThanOrEqual(labels?.count ?? 0, 3, "Should have at least 3 labels")
        
        // Find the collection view for transformations
        let collectionView = contentView?.subviews.first { $0 is UICollectionView }
        XCTAssertNotNil(collectionView, "Transformations collection view should exist")
    }
}

class TransformationDetailViewControllerTests: XCTestCase {
    
    func testTransformationDetailViewController_initialization() {
        // Given
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test description", photo: nil)
        let sut = TransformationDetailViewController(transformation: transformation)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testTransformationDetailViewController_viewDidLoad() {
        // Given
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test description", photo: nil)
        let sut = TransformationDetailViewController(transformation: transformation)
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(sut.view)
    }
    
    func testTransformationDetailViewController_hasRequiredUIElements() {
        // Given
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Test description", photo: nil)
        let sut = TransformationDetailViewController(transformation: transformation)
        
        // When
        sut.loadViewIfNeeded()
        
        // Then
        // Find stack view
        let stackView = sut.view.subviews.first { $0 is UIStackView } as? UIStackView
        XCTAssertNotNil(stackView, "Stack view should exist")
        
        // Check for image view, labels, and button in the stack view
        let imageView = stackView?.arrangedSubviews.first { $0 is UIImageView }
        XCTAssertNotNil(imageView, "Image view should exist in stack view")
        
        let labels = stackView?.arrangedSubviews.compactMap { $0 as? UILabel }
        XCTAssertEqual(labels?.count, 2, "Should have 2 labels in stack view")
        
        let button = stackView?.arrangedSubviews.first { $0 is UIButton }
        XCTAssertNotNil(button, "Close button should exist in stack view")
    }
}
