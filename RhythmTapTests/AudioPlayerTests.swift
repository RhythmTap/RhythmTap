//
//  AudioPlayerTests.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-25.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import XCTest
@testable import RhythmTap

class AudioPlayerTests: XCTestCase {

    var audioPlayer: AudioPlayer!
    
    override func setUp() {
        super.setUp()
        let file = "Trivial"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
        self.audioPlayer = AudioPlayer(audioTrack: audioTrack)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatAudioCanBePlayed() {
        XCTAssert(self.audioPlayer.playAudioTrack())
    }
    
    func testThatAudioIsPlaying() {
        self.audioPlayer.playAudioTrack()
        
        XCTAssertNotNil(self.audioPlayer.avAudioPlayer)
        XCTAssert(self.audioPlayer.avAudioPlayer!.playing)
    }
    
    func testThatAudioCanStopPlaying() {
        self.audioPlayer.playAudioTrack()
        self.audioPlayer.stopPlaying()
        
        XCTAssertFalse(self.audioPlayer.avAudioPlayer!.playing)
    }

}
