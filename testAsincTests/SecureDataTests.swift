//
//  SecureDataTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
import Combine
@testable import testAsinc

class SecureDataServiceTests: XCTestCase {
    var mockSecureData: MockSecureDataService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockSecureData = MockSecureDataService()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        mockSecureData = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSecureDataService_tokenStorage() {
        // Given
        let testToken = "test-token-123"
        
        // When
        mockSecureData.setToken(testToken)
        
        // Then
        XCTAssertEqual(mockSecureData.getToken(), testToken)
        
        // When
        mockSecureData.clearToken()
        
        // Then
        XCTAssertNil(mockSecureData.getToken())
    }
}


