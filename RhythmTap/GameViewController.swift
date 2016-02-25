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
    
    let tapCounter = Taps.init()
    let trackDirectory = "Tracks/"
    
    var audioPlayer: AudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = self.trackDirectory + "Easy"
        let audioFormat = "wav"
        let audioTrack = AudioTrack(file: file, audioFormat: audioFormat)
        self.audioPlayer = AudioPlayer(audioTrack: audioTrack)
        self.audioPlayer.play()
        
        counterLabel.text = String(tapCounter.getCount())
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
