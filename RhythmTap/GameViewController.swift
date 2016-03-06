//
//  GameViewController.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var correctTaps: UILabel!
    
    @IBOutlet weak var countdownLabel: UILabel!
    let tapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    var elapsedTime: NSTimeInterval = 0.0
    
    var audioPlayer: AudioPlayer!
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    var countdownTimer:NSTimer = NSTimer()
    
    var count: Int = 0
    var countdown: Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
        self.audioPlayer = AudioPlayer(audioTrack: audioTrack, controller: self)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountdown", userInfo: nil, repeats: true)
        //self.audioPlayer.play()
        
        countdownLabel.text = String(countdown)
        counterLabel.text = String(tapCounter.getCount())
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        elapsedTime = currentTime - startTime
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
            self.audioPlayer.play()
            countdownTimer.invalidate()
        }
        
    }
    
    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        tapCounter.increaseCount()
        counterLabel.text = String(tapCounter.getCount())
        gameView.backgroundColor = randomColour()
        if correctTap() {
            correctTaps.text = String(count++)
        
        }
    }
    
    
    // MARK: Interface
    func randomColour() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    //Checks to see if user tapped to the correct beat of 120 bpm
    func correctTap() -> Bool {
        if elapsedTime % (0.5) >= 0.40 || elapsedTime % (0.5) <= 0.1 {
            return true
        }
        else{
            return false
        }
    }
}
