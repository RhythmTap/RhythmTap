//
// Created by Brian Yip on 2016-03-14.
// Copyright (c) 2016 Brian Yip. All rights reserved.
//

import UIKit
import DynamicColor
import Foundation

enum Difficulty {
    case Easy
    case Intermediate
    case Hard
    case Insane
}

class DifficultyViewController : UIViewController {

    static let EasyColor = UIColor(hexString: "#66ffff")
    static let IntermediateColor = UIColor(hexString: "#ffff66")
    static let HardColor = UIColor(hexString: "#ff944d")
    static let InsaneColor = UIColor(hexString: "#ff3333")


    // MARK: Properties
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var insaneButton: UIButton!

    let loadingViewSegueIdentifier = "loadingViewSegue"

    var difficulty: Difficulty!
    var currentTrack: AudioTrack!


    // MARK: View overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateButtons()
        difficulty = Difficulty.Easy
    }

    
    // MARK: User Actions
    @IBAction func onEasy(sender: AnyObject) {
        difficulty = Difficulty.Easy
        animateSegueTransition(sender as! UIButton)
    }
    
    @IBAction func onIntermediate(sender: AnyObject) {
        difficulty = Difficulty.Intermediate
        animateSegueTransition(sender as! UIButton)
    }
    
    @IBAction func onHard(sender: AnyObject) {
        difficulty = Difficulty.Hard
        animateSegueTransition(sender as! UIButton)
    }
    
    @IBAction func onInsane(sender: AnyObject) {
        difficulty = Difficulty.Insane
        animateSegueTransition(sender as! UIButton)
    }


    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loadingViewSegueIdentifier {
            if let loadingViewController = segue.destinationViewController as? LoadingViewController {
                loadingViewController.difficulty = difficulty
                loadingViewController.currentTrack = currentTrack
            }
        }
    }


    // MARK: Helpers
    private func decorateButtons() {
        easyButton.layer.cornerRadius = 5
        easyButton.layer.backgroundColor = DifficultyViewController.EasyColor.CGColor
        intermediateButton.layer.cornerRadius = 5
        intermediateButton.layer.backgroundColor = DifficultyViewController.IntermediateColor.CGColor
        hardButton.layer.cornerRadius = 5
        hardButton.layer.backgroundColor = DifficultyViewController.HardColor.CGColor
        insaneButton.layer.cornerRadius = 5
        insaneButton.layer.backgroundColor = DifficultyViewController.InsaneColor.CGColor
    }

    private func animateSegueTransition(sender: UIButton) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(self.loadingViewSegueIdentifier, sender: sender)})
    }
}