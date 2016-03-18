//
//  GameViewController.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import DynamicColor
import AudioToolbox

class GameViewController: UIViewController, AdvancedAudioPlayerDelegate {
    
    // MARK: Properties
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var correctTaps: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var tapButton: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    
    let correctTapCounter = Taps.init()
    let incorrectTapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    let showScoreSegue = "showScore"
    
    var advancedAudioPlayer: AdvancedAudioPlayer!
    var audioAnalyzer: AudioAnalyzer!
    var elapsedTime: NSTimeInterval = 0.0
    var startTime = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    var countdownTimer:NSTimer = NSTimer()
    var countdown: Int = 3
    var songFinished: Bool = false
    var didFinishTrackSuccessfully: Bool = false
    var accuracy: Float = 0.0
    var taps: UInt = 0
    var difficulty: Difficulty!
    var totalTaps: UInt!
    var tapsFailState: UInt!
    var stickmenManager: StickmenManager = StickmenManager.init()

    
    // MARK: View Handlers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdvancedAudioPlayer()
        setupCountdownTimer()
        setTotalTaps()
        setDifficulty()
        tapButton.enabled = false
        self.navigationController?.navigationBarHidden = true
        
        testImage.image = stickmenManager.correctStickmen[0]
        testImage.image = testImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        testImage.tintColor = UIColor.blackColor()
    }
    
    
    // MARK: AdvancedAudioPlayerDelegate Implementation
    // This happens as soon as the track finishes playing
    func onTrackFinish() {
        songFinished = true
        didFinishTrackSuccessfully = true
        self.performSegueWithIdentifier(showScoreSegue, sender: self)
    }


    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        //Increments correct taps if user tapped on correct beat and the song isnt over
        if countdown == 0 {
            taps++
            if checkTap() && !songFinished {
                let random = Int(arc4random_uniform(UInt32(stickmenManager.correctStickmen.count)))
                let stickman = stickmenManager.correctStickmen[random]
                testImage.image = stickman
                testImage.image = testImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                correctTapCounter.increaseCount()
                correctTaps.text = String(correctTapCounter.getCount())
            }
                //If the user did not tap a correct tap, it was incorrect
            else {
                incorrectTapCounter.increaseCount()
                counterLabel.text = String(incorrectTapCounter.getCount())
                incorrectResponse(sender)
            }

            checkFailState()
        }
        testImage.tintColor = randomColour()
    }

    func checkFailState() {
        if incorrectTapCounter.getCount() >= tapsFailState {
            advancedAudioPlayer.pauseAudio()
            self.performSegueWithIdentifier(showScoreSegue, sender: self)
        }
    }


    // MARK: Navigation
    //Deals with the transitions between views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? ScoreViewController {
            dest.correctTaps = Float(correctTapCounter.getCount())
            dest.incorrectTaps = Float(counterLabel.text!)!
            dest.tapAccuracy =  accuracy / Float(taps)
            dest.didFinishTrackSuccessfully = didFinishTrackSuccessfully
        }
    }


    // MARK: Custom UI
    func randomColour() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func setDifficulty() {
        switch difficulty! {
            case .Easy:
                difficultyLabel.text = "Easy"
                difficultyLabel.textColor = DifficultyViewController.EasyColor
                tapsFailState = UInt(Double(totalTaps) * 0.75)
            case .Intermediate:
                difficultyLabel.text = "Intermediate"
                difficultyLabel.textColor = DifficultyViewController.IntermediateColor
                tapsFailState = UInt(Double(totalTaps) * 0.50)
            case .Hard:
                difficultyLabel.text = "Hard"
                difficultyLabel.textColor = DifficultyViewController.HardColor
                tapsFailState = UInt(Double(totalTaps) * 0.25)
            case .Insane:
                difficultyLabel.text = "Insane"
                difficultyLabel.textColor = DifficultyViewController.InsaneColor
                tapsFailState = UInt(Double(totalTaps) * 0.10)
        }
    }


    // MARK: Helpers
    private func secondsToMinutes(seconds: UInt32) -> Double {
        return Double(seconds) / 60.0;
    }

    private func setTotalTaps() {
        let minutes = secondsToMinutes(advancedAudioPlayer.getDurationSeconds())
        totalTaps = UInt(minutes * advancedAudioPlayer.getBpm())
    }


    
    // MARK: User Feedback
    func incorrectResponse(sender: UIButton) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))  // phone vibrate
        let bounds = sender.bounds
        // button jiggles
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: nil)
    }

    // Updates the beginning countdown every second
    func updateCountdown() {
        if countdown > 0 {  // if countdown still valid
            countdown--
            if countdown == 0 {
                countdownLabel.text = "Go!" // on the last one, go
            } else {
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

    
    // MARK: Audio and timing
    private func setupAdvancedAudioPlayer() {
        advancedAudioPlayer.delegate = self
    }
    
    private func setupCountdownTimer() {
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountdown", userInfo: nil, repeats: true)
        countdownLabel.text = String(countdown)
        counterLabel.text = String(correctTapCounter.getCount())
    }
    
    
    // Returns true if the tap is valid and checks how accurate the tap was
    func checkTap() -> Bool {

        // Update the BPM label for dynamic BPMs
        bpmLabel.text = String(advancedAudioPlayer.getCurrentBpm())

        let currentTapAccuracy = 100.0 - getOffBeatPercentage()
        accuracy += currentTapAccuracy

        var upperBoundTolerance: Float = 100.0;
        var lowerBoundTolerance: Float = 0.0;
        var tapTolerance: Float = 0

        // Keep in mind that switch statements in Swift do not fall through, therefore, break is not required
        switch difficulty! {
            case Difficulty.Easy:
                tapTolerance = 30;
            case Difficulty.Intermediate:
                tapTolerance = 20;
            case Difficulty.Hard:
                tapTolerance = 10;
            case Difficulty.Insane:
                tapTolerance = 5;
        }
        upperBoundTolerance -= tapTolerance
        lowerBoundTolerance += tapTolerance

        // Multiply beat index by 100 because the beat index is a float. Modular arithmetic
        // requires integers
        if (advancedAudioPlayer.getBeatIndex() * 100) % 100 >= upperBoundTolerance || (advancedAudioPlayer.getBeatIndex() * 100) % 100 <= lowerBoundTolerance {
            return true;
        }
        return false;
    }

    // Checks how offbeat your tap was
    private func getOffBeatPercentage() -> Float {
        var offBeat:Float = (advancedAudioPlayer.getBeatIndex() * 100) % 100
        if offBeat >= 50 {
            offBeat = (100 - offBeat) * 2
            return offBeat
        }
        return offBeat * 2
    }
    
}
