//
//  HomeViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var rhythmTap: UILabel!
    @IBOutlet weak var difficultyButton: UIButton!
    
    let transitionManager = TransitionManager()
    let loadingViewSegueIdentifier = "loadingViewSegue"
    let chooseLevelSegueIdentifier = "levelViewSegue"
    let chooseDifficultySegueIdentifier = "difficultyViewSegue"

    var difficulty: Difficulty!

    // MARK: View handling
    override func viewDidLoad() {
        super.viewDidLoad()
        decorateButtons()
        loadDefaultDifficulty()
    }


    // MARK: User actions
    @IBAction func startGame(sender: AnyObject) {
        let segueName = loadingViewSegueIdentifier
        animateSegueTransition(segueName, sender: sender as! UIButton)
    }
    
    @IBAction func chooseLevel(sender: AnyObject) {
        let segueName = chooseLevelSegueIdentifier
        animateSegueTransition(segueName, sender: sender as! UIButton)
    }
    
    @IBAction func chooseDifficulty(sender: AnyObject) {
        let segueName = chooseDifficultySegueIdentifier
        animateSegueTransition(segueName, sender: sender as! UIButton)
    }
    

    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.transitionManager.presenting = false
        if segue.identifier == loadingViewSegueIdentifier {
            if let loadingViewController = segue.destinationViewController as? LoadingViewController {
                loadingViewController.difficulty = difficulty
                loadingViewController.transitioningDelegate = self.transitionManager
            }
            return
        }
        if segue.identifier == "levelViewSegue" {
            if let levelView = segue.destinationViewController as? LevelViewController {
                levelView.difficulty = difficulty
            }
        }
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }


    // MARK: Private Interface
    private func decorateButtons() {
        startButton.layer.cornerRadius = 5
        levelButton.layer.cornerRadius = 5
        difficultyButton.layer.cornerRadius = 5
    }

    private func loadDefaultDifficulty() {
        if difficulty == nil {
            difficulty = Difficulty.Easy
        }
    }

    private func animateSegueTransition(segueName: String, sender: UIButton) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(segueName, sender: sender)})
    }

}

