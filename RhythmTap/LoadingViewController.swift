//
//  LoadingViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-08.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, AudioAnalyzerDelegate {

    // MARK: Properties
    let trackDirectory = "Tracks/"
    let advancedAudioPlayer = AdvancedAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAdvancedAudioPlayer()
    }
    
    
    // MARK: AudioAnalyzerDelegate Implementation
    // Called each time a sample is decoded when analyzing BPM
    func onFetchBpm(decoderSamplePosition: Double, finishPosition decoderDurationSamples: Double) {
        let progress = decoderSamplePosition / decoderDurationSamples
        print(progress)
    }
    
    // Called once the BPM is analyzed
    func doneFetchingBpm() {
        print("Done analyzing BPM!")
    }
    
    // MARK: Private Interface
    func setupAdvancedAudioPlayer() {
        let audioAnalyzer = AudioAnalyzer()
        audioAnalyzer.delegate = self
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file, audioFormat: audioFormat)
        advancedAudioPlayer.prepareAudioPlayer(audioAnalyzer, trackToAnalyze: audioTrack)
    }
}
