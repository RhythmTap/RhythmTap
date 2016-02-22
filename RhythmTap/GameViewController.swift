//
//  GameViewController.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let tapCounter = Taps.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterLabel.text = String(tapCounter.getCount())
    }
    
    @IBAction func onTap(sender: UIButton) {
        tapCounter.increaseCount()
        counterLabel.text = String(tapCounter.getCount())
        gameView.backgroundColor = randomColour()
    }
    
    func randomColour() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
