//
//  AudioPlayer.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-25.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    // MARK: Properties
    var audioTrack: AudioTrack!
    var avAudioPlayer: AVAudioPlayer?
    
    var gameViewController: GameViewController
    
    
    // MARK: Initialization:
    init(audioTrack: AudioTrack, controller: GameViewController) {
        self.audioTrack = audioTrack
        gameViewController = controller
    }
    
    override init() {
        self.audioTrack = AudioTrack()
        self.gameViewController = GameViewController()
    }
    
    
    // MARK: Interface
    func play() -> Bool {
        
        do {
            if let path = NSBundle.mainBundle().pathForResource(self.audioTrack.file as String, ofType: self.audioTrack.audioFormat as String) {
                let url = NSURL.fileURLWithPath(path)
                self.avAudioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.avAudioPlayer?.delegate = self
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
    
    //Stops the timer when the audio is done playing
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
//        successfully flag: Bool) {
//        gameViewController.timer.invalidate()
//    }
//    
}