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
    
    var advancedAudioPlayer: AdvancedAudioPlayer?
//    var startTime = NSTimeInterval()
//    var timer:NSTimer = NSTimer()
    
    var count: Int = 0;
    
    
    /* Screen Loading overrides */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if advancedAudioPlayer == nil {
            advancedAudioPlayer = AdvancedAudioPlayer()
            let file = self.trackDirectory + "Easy"
            let audioFormat = "wav"
            let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
            if advancedAudioPlayer!.playAudio(audioTrack.file) {
                print("Playing audio!")
            }
        }
        
        counterLabel.text = String(tapCounter.getCount())
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.advancedAudioPlayer != nil {
            self.advancedAudioPlayer?.pauseAudio()
            self.advancedAudioPlayer = nil
        }        
    }
    
    
    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        tapCounter.increaseCount()
        counterLabel.text = String(tapCounter.getCount())
        gameView.backgroundColor = randomColour()
    }
    
    // MARK: Interface
    func randomColour() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
