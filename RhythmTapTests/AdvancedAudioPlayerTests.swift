//
//  SwiftToObjcTests.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import RhythmTap

class SwiftToObjcTests: XCTestCase {

    let advancedAudioPlayer = AdvancedAudioPlayer()
    var audioTrack: AudioTrack!
    
    override func setUp() {
        super.setUp()
        let file = "Tracks/Easy"
        let audioFormat = "wav"
        self.audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatAudioCanBePlayed() {
        XCTAssertTrue(self.advancedAudioPlayer.playAudio());
    }
    
    func testThatAudioCanBePaused() {
        self.advancedAudioPlayer.playAudio();
        XCTAssertTrue(self.advancedAudioPlayer.pauseAudio());
    }

}
