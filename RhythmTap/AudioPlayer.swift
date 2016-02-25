//
//  AudioPlayer.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-25.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    // MARK: Properties
    var audioTrack: AudioTrack!
    var avAudioPlayer: AVAudioPlayer?
    
    
    // MARK: Initialization:
    init(audioTrack: AudioTrack) {
        self.audioTrack = audioTrack
    }
    
    init() {
        self.audioTrack = AudioTrack()
    }
    
    
    // MARK: Interface
    func play() -> Bool {
        
        do {
            if let path = NSBundle.mainBundle().pathForResource(self.audioTrack.file as String, ofType: self.audioTrack.audioFormat as String) {
                let url = NSURL.fileURLWithPath(path)
                self.avAudioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.avAudioPlayer!.play()
                return true
            }
        } catch {
            return false
        }

        return false
        
    }
    
    func stop() {
        if self.avAudioPlayer != nil {
            self.avAudioPlayer?.stop()
        }
    }
    
}