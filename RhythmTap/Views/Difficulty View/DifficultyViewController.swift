//
// Created by Brian Yip on 2016-03-14.
// Copyright (c) 2016 Brian Yip. All rights reserved.
//

import UIKit
import Foundation

public enum Difficulty {
    case Easy
    case Intermediate
    case Hard
    case Insane
}

class DifficultyViewController : UIViewController {

    // MARK: Properties
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var insaneButton: UIButton!

    let homeViewSegueIdentifier = "homeViewSegue"

    var difficulty: Difficulty!


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
        if segue.identifier == homeViewSegueIdentifier {
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.difficulty = difficulty
            }
        }
    }


    // MARK: Helpers
    private func decorateButtons() {
        easyButton.layer.cornerRadius = 5
        intermediateButton.layer.cornerRadius = 5
        hardButton.layer.cornerRadius = 5
        insaneButton.layer.cornerRadius = 5
    }

    private func animateSegueTransition(sender: UIButton) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(self.homeViewSegueIdentifier, sender: sender)})
    }
}
