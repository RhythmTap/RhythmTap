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
    
    let tapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    var elapsedTime: NSTimeInterval = 0.0
    
    var audioPlayer: AudioPlayer!
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    
    var count: Int = 0;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
        self.audioPlayer = AudioPlayer(audioTrack: audioTrack, controller: self)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        self.audioPlayer.play()
        
        counterLabel.text = String(tapCounter.getCount())
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        elapsedTime = currentTime - startTime
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
