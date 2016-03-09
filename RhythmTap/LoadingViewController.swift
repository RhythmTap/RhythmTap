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
    let trackDirectory = "Tracks/"
    let advancedAudioPlayer = AdvancedAudioPlayer()
    
    
    // View actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    
    // MARK: Private Interface
    private func setupAdvancedAudioPlayer() {
        
        //The solution is to port the analyzer to ObjC land because it is not possible to convert Swift strings to ObjC strings
        
        
        let file = self.trackDirectory + "lycka"
        let audioFormat = "mp3"
        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
        let audioAnalyzer = AudioAnalyzer(audioTrack)
        audioAnalyzer.delegate = self
        advancedAudioPlayer.prepareAudioPlayer(audioAnalyzer, trackToAnalyze: audioTrack)
    }
    
    private func updateProgressBar(progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
}
