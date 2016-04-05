//
//  LoadingViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-08.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import Foundation

class LoadingViewController: UIViewController, AudioAnalyzerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var progressBar: UIProgressView!

    let gameViewSegueIdentifier = "GameViewSegue"
    let advancedAudioPlayer = AdvancedAudioPlayer()

    var difficulty: Difficulty!
    var currentTrack: AudioTrack!
    
    
    // View actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(animated: Bool) {
        let start:Float = 0.0;
        updateProgressBar(start);
    }
    
    override func viewDidAppear(animated: Bool) {
        setupAdvancedAudioPlayer()
    }
    
    
    // MARK: AudioAnalyzerDelegate Implementation
    // Called each time a sample is decoded when analyzing BPM
    func onFetchBpm(decodedSamples: Double, finishPosition totalSamples: Double) {
        let progress = Float(decodedSamples / totalSamples)
        updateProgressBar(progress)
    }
    
    // Called once the BPM is analyzed
    func doneFetchingBpm() {
        print("Detected BPM: " + String(advancedAudioPlayer.getCurrentBpm()))
        performSegueWithIdentifier(gameViewSegueIdentifier, sender: self)
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameViewController = segue.destinationViewController as! GameViewController
        gameViewController.advancedAudioPlayer = self.advancedAudioPlayer
        gameViewController.difficulty = difficulty
        gameViewController.currentTrack = currentTrack
    }
    
    
    // MARK: Private Interface
    private func setupAdvancedAudioPlayer() {
        let audioAnalyzer = AudioAnalyzer(currentTrack)
        audioAnalyzer.delegate = self
        advancedAudioPlayer.prepareAudioPlayer(self, audioTrackToPrepare: currentTrack)
    }
    
    private func updateProgressBar(progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
}
