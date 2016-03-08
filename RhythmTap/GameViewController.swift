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
    
    var advancedAudioPlayer: AdvancedAudioPlayer!
    
    // Screen Loading overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file, audioFormat: audioFormat)
        
        advancedAudioPlayer = AdvancedAudioPlayer()
        advancedAudioPlayer.prepareAudioPlayer(audioTrack)
        if advancedAudioPlayer.playAudio(audioTrack) {
                print("Playing audio!")
         }
        
        countdownLabel.text = String(countdown)
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
    
    // MARK: Private Interface
    /*
        Returns true if the tap is valid
    */
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
