//
//  HomeViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var rhythmTap: UILabel!
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 5
        levelButton.layer.cornerRadius = 5
        startButton.tag = 1
        levelButton.tag = 2
    }
    
    @IBAction func shake(sender: UIButton) {
        var segueName = ""
        if sender.tag == 1 {
            segueName = "gameView"
        }
        else if sender.tag == 2 {
            segueName = "levelView"
        }
        
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
            //sender.enabled = false
            }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(segueName, sender: sender)})
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }
    
}

