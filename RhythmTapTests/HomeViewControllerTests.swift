//
//  HomeViewControllerTests.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import RhythmTap

class HomeViewControllerTests: XCTestCase {
    
    var controller: HomeViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("HomeViewNavigationController") as! UINavigationController
        self.controller = navigationController.topViewController as! HomeViewController
        
        // Test and load the view at the same time
        XCTAssertNotNil(navigationController.view, "HomeViewNavigationController's view is nil")
        XCTAssertNotNil(self.controller.view, "HomeViewController's view is nil")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
}
