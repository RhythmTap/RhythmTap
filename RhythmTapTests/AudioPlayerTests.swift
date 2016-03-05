////
////  AudioPlayerTests.swift
////  RhythmTap
////
////  Created by Brian Yip on 2016-02-25.
////  Copyright © 2016 Brian Yip. All rights reserved.
////
//
//import XCTest
//@testable import RhythmTap
//
//class AudioPlayerTests: XCTestCase {
//
//    var audioPlayer: AudioPlayer!
//    
//    override func setUp() {
//        super.setUp()
//        let file = "Tracks/Trivial"
//        let audioFormat = "wav"
//        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
//        self.audioPlayer = AudioPlayer(audioTrack: audioTrack)
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//    }
//    
//    func testThatAudioCanBePlayed() {
//        XCTAssert(self.audioPlayer.play())
//    }
//    
//    func testThatAudioIsPlaying() {
//        self.audioPlayer.play()
//        
//        XCTAssertNotNil(self.audioPlayer.avAudioPlayer)
//        XCTAssert(self.audioPlayer.avAudioPlayer!.playing)
//    }
//    
//    func testThatAudioCanStopPlaying() {
//        self.audioPlayer.play()
//        self.audioPlayer.stop()
//        
//        XCTAssertFalse(self.audioPlayer.avAudioPlayer!.playing)
//    }
//
//}
