//
//  GameViewController.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController, AdvancedAudioPlayerDelegate {
    
    // MARK: Properties
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var correctTaps: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var tapButton: UILabel!
    
    let correctTapCounter = Taps.init()
    let incorrectTapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    
    var elapsedTime: NSTimeInterval = 0.0
    var advancedAudioPlayer: AdvancedAudioPlayer!
    var audioAnalyzer: AudioAnalyzer!
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    var countdownTimer:NSTimer = NSTimer()
    var countdown: Int = 3
    var songFinished: Bool = false
    
    
    // MARK: View Handlers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdvancedAudioPlayer()
        setupCountdownTimer()
        tapButton.enabled = false
        self.navigationController?.navigationBarHidden = true
    }
    
    
    // MARK: AdvancedAudioPlayerDelegate Implementation
    // This happens as soon as the track finishes playing
    func onTrackFinish() {
        songFinished = true
        self.performSegueWithIdentifier("showScore", sender: self)
    }
    
    
    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        //Increments correct taps if user tapped on correct beat and the song isnt over
        if checkTap() && !songFinished {
            correctTapCounter.increaseCount()
            correctTaps.text = String(correctTapCounter.getCount())
        }
        //If the user did not tap a correct tap, it was incorrect
        else {
            incorrectTapCounter.increaseCount()
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            counterLabel.text = String(incorrectTapCounter.getCount())
            jiggleButton(sender)
            
        }
        gameView.backgroundColor = randomColour()
    }
    
    func jiggleButton(sender: UIButton) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
            }, completion: nil)
    }
    
    //Deals with the transitions between views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? ScoreViewController {
            dest.correctTaps = Float(correctTaps.text!)!
            dest.incorrectTaps = Float(counterLabel.text!)!
        }
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
            tapButton.enabled = true
            self.advancedAudioPlayer.playAudio()
            countdownTimer.invalidate()
        }
    }
    
    
    
    // MARK: Private Interface
    func setupAdvancedAudioPlayer() {
        advancedAudioPlayer.delegate = self
    }
    
    func setupCountdownTimer() {
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountdown", userInfo: nil, repeats: true)
        countdownLabel.text = String(countdown)
        counterLabel.text = String(correctTapCounter.getCount())
    }
    
    
    // Returns true if the tap is valid
    func checkTap() -> Bool {
        // Multiply beat index by 100 because the beat index is a float. Modular arithmetic
        // requires integers
        let upperBoundTolerance:Float = 80.0;
        let lowerBoundTolerance:Float = 20.0;
        if (advancedAudioPlayer.getBeatIndex() * 100) % 100 >= upperBoundTolerance || (advancedAudioPlayer.getBeatIndex() * 100) % 100 <= lowerBoundTolerance {
            print(advancedAudioPlayer.getBeatIndex())
            return true;
        }
        return false;
    }
    
}
