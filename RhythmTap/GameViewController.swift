//
//  GameViewController.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, AdvancedAudioPlayerDelegate {
    
    // MARK: Properties
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var correctTaps: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    let tapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    
    var elapsedTime: NSTimeInterval = 0.0
    var advancedAudioPlayer: AdvancedAudioPlayer!
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    var countdownTimer:NSTimer = NSTimer()
    var countdown: Int = 3
    
    
    // MARK: View Handlers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdvancedAudioPlayer()
        setupCountdownTimer()
    }
    
    
    // MARK: AdvancedAudioPlayerDelegate Implementation
    // This happens as soon as the track finishes playing
    func onTrackFinish() {
        print("GameViewController: Good!!!")
    }
    
    
    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        if checkTap() {
            tapCounter.increaseCount()
            counterLabel.text = String(tapCounter.getCount())
        }
        gameView.backgroundColor = randomColour()
    }
    
    
    
    // MARK: Interface
    func randomColour() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // Updates the beginning countdown every second
    func updateCountdown() {
        if countdown > 0 {  // if countdown still valid
            countdown--
            if countdown == 0 {
                countdownLabel.text = "Go!" // on the last one, go
            }
            else {
                countdownLabel.text = String(countdown) // update countdown
            }
        }
        else {   // play music, hide label when finished counting down
            countdownLabel.hidden = true
            self.advancedAudioPlayer.playAudio()
            countdownTimer.invalidate()
        }
    }
    
    
    
    // MARK: Private Interface
    func setupAdvancedAudioPlayer() {
        let audioAnalyzer = AudioAnalyzer()
        
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file, audioFormat: audioFormat)
        advancedAudioPlayer = AdvancedAudioPlayer()
        advancedAudioPlayer.prepareAudioPlayer(audioAnalyzer, trackToAnalyze: audioTrack)
        advancedAudioPlayer.delegate = self
    }
    
    func setupCountdownTimer() {
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountdown", userInfo: nil, repeats: true)
        countdownLabel.text = String(countdown)
        counterLabel.text = String(tapCounter.getCount())
    }
    
    
    // Returns true if the tap is valid
    func checkTap() -> Bool {
        // Multiply beat index by 100 because the beat index is a float. Modular arithmetic
        // requires integers
        let upperBoundTolerance:Float = 90.0;
        let lowerBoundTolerance:Float = 10.0;
        if (advancedAudioPlayer.getBeatIndex() * 100) % 100 >= upperBoundTolerance || (advancedAudioPlayer.getBeatIndex() * 100) % 100 <= lowerBoundTolerance {
            print(advancedAudioPlayer.getBeatIndex())
            return true;
        }
        return false;
    }
}
