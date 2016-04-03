//
//  SwiftAudioAnalyzerTests.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import RhythmTap

class SwiftAudioAnalyzerTests: XCTestCase {

    var analyzer: AudioAnalyzer!
    var audioTrack: AudioTrack!
    var testThatBpmCanBeFetchedExpectation: XCTestExpectation!
    var testThatBpmCanBeFetchedDefaultConstructorExpectation: XCTestExpectation!
    var testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        let file = "Tracks/Easy"
        let audioFormat = "wav"
        self.audioTrack = AudioTrack(songName: file, audioFormat: audioFormat)
        self.analyzer = AudioAnalyzer(audioTrack)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultTrackDurationCanBeFetched() {
        let expectedTrackDuration:Float = 8.00;
    
        XCTAssertEqual(self.analyzer.getTrackDurationInSeconds(), expectedTrackDuration);
    }
    
    
    // If you need help on swift closures, look here: https://www.weheartswift.com/closures/
    func testThatBpmCanBeFetched() {
        let expectedBpm:Float = 120.0;
        
        // Set the expectation timer
        self.testThatBpmCanBeFetchedExpectation = expectationWithDescription("BPM should have been set")
        
        
        // Define the closure block
        let callback: (Float) -> (Void) = { bpm in
            // Asynchronously fulfill the test expectation
            self.testThatBpmCanBeFetchedExpectation.fulfill()
            XCTAssertEqual(bpm, expectedBpm)
        }
        
        // Asynchronously process the BPM
        self.analyzer.asyncProcessBpm(callback)
        
        // If we timeout, something went wrong
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testThatBpmCanBeFetchedDefaultConstructor() {
        let expectedBpm:Float = 120.0
        let analyzer = AudioAnalyzer()
        analyzer.open(self.audioTrack)
        
        self.testThatBpmCanBeFetchedDefaultConstructorExpectation = expectationWithDescription("BPM should have been set")
        
        
        let callback: (Float) -> (Void) = { bpm in
            self.testThatBpmCanBeFetchedDefaultConstructorExpectation.fulfill()
            XCTAssertEqual(bpm, expectedBpm)
        }
        
        self.analyzer.asyncProcessBpm(callback)
        
        // If we timeout, something went wrong
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testThatBpmCanBeFetchedDefaultConstructorDifferentThread() {
        let expectedBpm:Float = 120.0
        let analyzer = AudioAnalyzer()
        analyzer.open(self.audioTrack)
        
        // Set the expectation timer
        self.testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation = expectationWithDescription("BPM should have been set")
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let callback: (Float) -> (Void) = { bpm in
                self.testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation.fulfill()
                XCTAssertEqual(bpm, expectedBpm)
            }
            self.analyzer.asyncProcessBpm(callback)
        })
        
        
        // If we timeout, something went wrong
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }

}
