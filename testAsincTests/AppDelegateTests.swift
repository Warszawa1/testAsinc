//
//  AppDelegateTests.swift
//  testAsincTests
//
//  Created by Ire  Av on 9/5/25.
//

import XCTest
@testable import testAsinc

class AppDelegateTests: XCTestCase {
    
    var appDelegate: AppDelegate!
    
    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
    }
    
    override func tearDown() {
        appDelegate = nil
        super.tearDown()
    }
    
    func testAppDelegate_initialization() {
        XCTAssertNotNil(appDelegate)
    }
    
    func testApplicationDidFinishLaunching() {
        let result = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(result)
    }
}
