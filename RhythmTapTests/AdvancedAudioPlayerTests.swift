//
//  AdvancedAudioPlayerTests.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import RhythmTap

class AdvancedAudioPlayerTests: XCTestCase, AudioAnalyzerDelegate {

    let advancedAudioPlayer = AdvancedAudioPlayer()
    var audioTrack: AudioTrack!
    var testThatAdvancedAudioPlayerCanBePreparedExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        let file = "Tracks/Easy"
        let audioFormat = "wav"
        self.audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: AudioAnalyzerDelegate Implementation
    func onFetchBpm(decodedSamples: Double, finishPosition totalSamples: Double) {
        
    }
    
    func doneFetchingBpm() {
        let expectedBpm = 120.0
        self.testThatAdvancedAudioPlayerCanBePreparedExpectation.fulfill()
        XCTAssertEqual(self.advancedAudioPlayer.getCurrentBpm(), expectedBpm)
    }

    
    // MARK: Test cases
    func testThatAudioCanBePlayed() {
        XCTAssertTrue(self.advancedAudioPlayer.playAudio());
    }
    
    func testThatAudioCanBePaused() {
        self.advancedAudioPlayer.playAudio();
        XCTAssertTrue(self.advancedAudioPlayer.pauseAudio());
    }
    
    func testThatAdvancedAudioPlayerCanBePrepared() {
        
        testThatAdvancedAudioPlayerCanBePreparedExpectation = expectationWithDescription("The BPM should not be 0.0")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let audioAnalyzer = AudioAnalyzer()
            audioAnalyzer.open(self.audioTrack)
            self.advancedAudioPlayer.prepareAudioPlayer(self, audioTrackToPrepare: self.audioTrack)
        })
        
        // If we timeout, something went wrong
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }

}
