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
    @IBOutlet weak var stickman: UIImageView!
    @IBOutlet weak var tapLabel: UILabel!
    
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
    var totalCorrectTaps: UInt!
    var totalIncorrectTaps: UInt!
    var currentTrack: AudioTrack!
    var stickmenManager: StickmenManager = StickmenManager.init()

    
    // MARK: View Handlers
    override func viewDidLoad() {
        super.viewDidLoad()
        tapButton.enabled = false
        self.navigationController?.navigationBarHidden = true
        setupAdvancedAudioPlayer()
        setupCountdownTimer()
        setTotalTaps()
        setDifficulty()
        loadStickMan()
    }

    // MARK: Loading
    func setupAdvancedAudioPlayer() {
        advancedAudioPlayer.delegate = self
    }

    func setupCountdownTimer() {
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountdown", userInfo: nil, repeats: true)
        countdownLabel.text = String(countdown)
        counterLabel.text = String(correctTapCounter.getCount())
    }

    func secondsToMinutes(seconds: UInt32) -> Double {
        return Double(seconds) / 60.0;
    }

    func setTotalTaps() {
        let minutes = secondsToMinutes(advancedAudioPlayer.getDurationSeconds())
        totalCorrectTaps = UInt(minutes * advancedAudioPlayer.getBpm())
    }

    func setDifficulty() {
        switch difficulty! {
        case .Easy:
            difficultyLabel.text = "Easy"
            difficultyLabel.backgroundColor = DifficultyViewController.EasyColor
            totalIncorrectTaps = UInt(Double(totalCorrectTaps) * 0.75)
        case .Intermediate:
            difficultyLabel.text = "Intermediate"
            difficultyLabel.backgroundColor = DifficultyViewController.IntermediateColor
            totalIncorrectTaps = UInt(Double(totalCorrectTaps) * 0.50)
        case .Hard:
            difficultyLabel.text = "Hard"
            difficultyLabel.backgroundColor = DifficultyViewController.HardColor
            totalIncorrectTaps = UInt(Double(totalCorrectTaps) * 0.25)
        case .Insane:
            difficultyLabel.text = "Insane"
            difficultyLabel.backgroundColor = DifficultyViewController.InsaneColor
            totalIncorrectTaps = UInt(Double(totalCorrectTaps) * 0.10)
        }
    }

    func loadStickMan() {
        stickman.image = stickmenManager.correctStickmen[0]
        stickman.image = stickman.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        stickman.tintColor = UIColor.blackColor()
    }
    
    
    // MARK: AdvancedAudioPlayerDelegate Implementation
    // This happens as soon as the track finishes playing
    func onTrackFinish() {
        songFinished = true
        if (correctTapCounter.getCount() >= totalCorrectTaps / 2) {
            didFinishTrackSuccessfully = true
        }
        self.performSegueWithIdentifier(showScoreSegue, sender: self)
    }


    // MARK: User Actions
    @IBAction func onTap(sender: UIButton) {
        //Increments correct taps if user tapped on correct beat and the song isnt over
        if countdown == 0 {
            taps += 1
            changeTapLabel(taps);
            if checkTap() && !songFinished {
                performCorrectTap()
            } else {
                performIncorrectTap()
            }
            checkFailState()
        }
    }

    func performCorrectTap() {
        let isTapCorrect = true
        stickmanDance(isTapCorrect)
        incrementCorrectTapCounter()
    }

    func performIncorrectTap() {
        let isTapCorrect = false
        stickmanDance(isTapCorrect)
        incrementIncorrectTapCounter()
    }
    
    func changeTapLabel(taps: UInt) {
        tapLabel.textColor = randomColour()
        if taps % 2 == 0 {
            tapLabel.transform = CGAffineTransformMakeRotation(CGFloat((M_PI_4)/2))
        }
        else {
            tapLabel.transform = CGAffineTransformMakeRotation(CGFloat((-M_PI_4))/2)
        }
       
    }

    func stickmanDance(isTapCorrect: Bool) {
        var random = Int(arc4random_uniform(UInt32(stickmenManager.correctStickmen.count)))
        var newStickman = stickmenManager.correctStickmen[random]
        stickman.tintColor = randomColour().saturatedColor()
        if (!isTapCorrect) {
            random = Int(arc4random_uniform(UInt32(stickmenManager.incorrectStickmen.count)))
            newStickman = stickmenManager.incorrectStickmen[random]
            stickman.tintColor = UIColor.blackColor()
            incorrectResponse(stickman)
        }
        stickman.image = newStickman
        stickman.image = stickman.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
    }

    func incrementCorrectTapCounter() {
        correctTapCounter.increaseCount()
        correctTaps.text = String(correctTapCounter.getCount()) + "/" + String(totalCorrectTaps)
    }

    func incrementIncorrectTapCounter() {
        incorrectTapCounter.increaseCount()
        counterLabel.text = String(incorrectTapCounter.getCount()) + "/" + String(totalIncorrectTaps)
    }

    func checkFailState() {
        if incorrectTapCounter.getCount() >= totalIncorrectTaps {
            self.performSegueWithIdentifier(showScoreSegue, sender: self)
        } else if correctTapCounter.getCount() >= totalCorrectTaps {
            didFinishTrackSuccessfully = true
            self.performSegueWithIdentifier(showScoreSegue, sender: self)
        }
    }

    func stopAudioPlayer() {
        if (accuracy > 0) {
            accuracy = accuracy / Float(taps)
        }
        advancedAudioPlayer.pauseAudio()
    }


    // MARK: Navigation
    //Deals with the transitions between views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        stopAudioPlayer()
        if let dest = segue.destinationViewController as? ScoreViewController {
            dest.currentTrack = currentTrack
            dest.difficulty = difficulty
            dest.correctTaps = Float(correctTapCounter.getCount())
            dest.incorrectTaps = Float(incorrectTapCounter.getCount())
            dest.tapAccuracy = accuracy
            dest.expectedCorrectTaps = totalCorrectTaps
            dest.expectedIncorrectTaps = totalIncorrectTaps
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


    // MARK: User Feedback
    func incorrectResponse(sender: UIImageView) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))  // phone vibrate
        let bounds = sender.bounds

        // button jiggles
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 26, y: bounds.origin.y, width: bounds.size.width - 60, height: bounds.size.height)
        }, completion: nil)

        sender.bounds = bounds  // stop shrinking image
    }

    // Updates the beginning countdown every second
    func updateCountdown() {
        if countdown > 0 {
            // if countdown still valid
            countdown -= 1
            if countdown == 0 {
                countdownLabel.text = "Go!" // on the last one, go
                return
            }
            countdownLabel.text = String(countdown) // update countdown
            return
        }
        playAudioAndHideLabel()
    }

    func playAudioAndHideLabel() {
        countdownLabel.hidden = true
        tapButton.enabled = true
        self.advancedAudioPlayer.playAudio()
        countdownTimer.invalidate()
    }

    // MARK: Audio and timing
    struct Tolerance {
        var upperBound: Float = 100.0
        var lowerBound: Float = 0.0
    }

    // Returns true if the tap is valid and checks how accurate the tap was
    func checkTap() -> Bool {

        // Update the BPM label for dynamic BPMs
        bpmLabel.text = String(format: "%.3f", advancedAudioPlayer.getCurrentBpm())
        let currentTapAccuracy = 100.0 - getOffBeatPercentage()
        accuracy += currentTapAccuracy
        let tolerance = computeCorrectTapTolerance()

        // Multiply beat index by 100 because the beat index is a float. Modular arithmetic
        // requires integers
        if (advancedAudioPlayer.getBeatIndex() * 100) % 100 >= tolerance.upperBound || (advancedAudioPlayer.getBeatIndex() * 100) % 100 <= tolerance.lowerBound {
            return true;
        }
        return false;

    }

    // Returns true if the
    func computeCorrectTapTolerance() -> Tolerance {
        var upperBound: Float = 100.0
        var lowerBound: Float = 0.0
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
        upperBound -= tapTolerance
        lowerBound += tapTolerance
        return Tolerance(upperBound: upperBound, lowerBound: lowerBound)
    }

    // Checks how offbeat your tap was
    func getOffBeatPercentage() -> Float {
        var offBeat:Float = (advancedAudioPlayer.getBeatIndex() * 100) % 100
        if offBeat >= 50 {
            offBeat = (100 - offBeat) * 2
            return offBeat
        }
        return offBeat * 2
    }

}
