//
//  ScoreViewController.swift
//  RhythmTap
//
//  Created by Jennifer Terpstra on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import DynamicColor

class ScoreViewController: UIViewController {
    
    var correctTaps: Float = 0
    var incorrectTaps: Float = 0
    var didFinishTrackSuccessfully: Bool = false
    var tapAccuracy: Float!
    var score: Float!
    var difficulty: Difficulty!
    var songName: String!
    var expectedCorrectTaps: UInt!
    var expectedIncorrectTaps: UInt!
    var songNames : [String] = [String]()
    
    var level: Int!
    
    let transitionManager = TransitionManager()
    let failText = "Oh no! You failed the rhythm!"
    let successText = "Congratulations! You have endured the rhythm!"
    let failTextColor = UIColor(hexString: "#ff6666")
    let successTextColor = UIColor(hexString: "#66ff66")
    let changeDifficultySegueIdentifier = "changeDifficultySegue"
    let redoLevelSegueIdentifier = "redoLevelSegue"
    let nextLevelSegueIdentifier = "nextLevelSegue"
    let homeViewSegueIdentifier = "homeViewSegue"

    @IBOutlet weak var gameStateLabel: UILabel!
    @IBOutlet weak var showNewHighScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var correctTapsLabel: UILabel!
    @IBOutlet weak var incorrectTapsLabel: UILabel!
    @IBOutlet weak var changeDifficultyButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var nextLevelButton: UIButton!
    
    let managedContext = (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    var scores = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFinishedTrackStatus()
        decorateButtons()
        homeButton.tag = 1
        score = tapAccuracy
        
        showNewHighScoreLabel.hidden = true
        
        accuracyLabel.text = String(tapAccuracy) + "%"
        correctTapsLabel.text = String(Int(correctTaps)) + "/" + String(expectedCorrectTaps)
        incorrectTapsLabel.text = String(Int(incorrectTaps)) + "/" + String(expectedIncorrectTaps)
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(NSBundle.mainBundle().bundlePath + "/Tracks/")!
        var count = 0
        
        while let file = enumerator.nextObject() as! String? {
            if(file.hasSuffix(".wav")) {
                songNames.append(file.stringByReplacingOccurrencesOfString(".wav", withString: ""))
                count += 1
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Score")  // get entity
        do {
            // fetch scores into results
            let results = try managedContext.executeFetchRequest(fetchRequest)
            scores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } catch {
            print("Failed to fetch request")
        }

        self.navigationItem.hidesBackButton = true

        let scoreResult = getHighScore()

        if String(scoreResult) == "" {  // if this level hasn't been played
            newLevelScore()
            showNewHighScoreLabel.hidden = false
            print("New high score!" + String(score))
        }
        else {  // if this level has been played
            let scoreObject = scoreResult as! NSManagedObject
            let scoreValue = scoreObject.valueForKey("highScore")   // get high score
            if Float(scoreValue! as! NSNumber) < score {
                newHighScore(scoreObject) // establish new high score
                showNewHighScoreLabel.hidden = false
                highScoreLabel.text = String(score)+"%"
            }
            else {
                print("High score: " + String(scoreValue!))  // show current high score
                highScoreLabel.text = (String(scoreValue!))+"%"
            }
        }
    }

    // MARK: User Interaction
    @IBAction func onChangeDifficulty(sender: UIButton) {
        animateSegueTransition(sender, segueIdentifier: self.changeDifficultySegueIdentifier)
    }
    
    @IBAction func onRedoLevel(sender: UIButton) {
        animateSegueTransition(sender, segueIdentifier: self.redoLevelSegueIdentifier)
    }
    
    @IBAction func onNextLevel(sender: UIButton) {
        animateSegueTransition(sender, segueIdentifier: self.nextLevelSegueIdentifier)
    }

    @IBAction func onHome(sender: UIButton) {
        animateSegueTransition(sender, segueIdentifier: self.homeViewSegueIdentifier)
    }
    
    // establishes a new high score for this level and difficulty
    func newHighScore(scoreObject: NSManagedObject) {
        print("New high score! Level " + String(level) + ", difficulty " + String(difficulty) + ", score " + String(score))
        highScoreLabel.text = String(score)+"%"
        scoreObject.setValue(score, forKey: "highScore")    // set value
        do {
            try scoreObject.managedObjectContext?.save()    // save change
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    // establishes a high score for this level and difficulty
    func newLevelScore() {
        let scoreEntity =  NSEntityDescription.entityForName("Score", inManagedObjectContext:managedContext)  // get object containing score
        let newScore = NSManagedObject(entity: scoreEntity!, insertIntoManagedObjectContext: managedContext)  // create new row
        newScore.setValue(score, forKey: "highScore") // set high score
        highScoreLabel.text = String(score)+"%"
        newScore.setValue(level, forKey: "level")   // set level
        newScore.setValue(String(difficulty), forKey: "difficulty") // set difficulty
        
        //4
        do {
            try managedContext.save()
            //5
            scores.append(newScore) // save addition
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Could not save")
        }
    }
    
    func getHighScore() -> AnyObject {
        let entries : NSArray = scores

        level = songNames.indexOf(songName)! + 1
        
        // search for the value
        let predicate = NSPredicate(format: "level = %i AND difficulty = %@", level, String(difficulty))
        
        // filter results accordingly
        var searchScores = entries.filteredArrayUsingPredicate(predicate)
        if searchScores.count != 0 {    // if there exists a score, update
            return searchScores[0]
        }
        else {  // otherwise, return nothing
            return ""
        }
    }


    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.homeViewSegueIdentifier {
            if let homeViewController = segue.destinationViewController as? HomeViewController {
                homeViewController.songName = songName
                self.transitionManager.presenting = false
                homeViewController.transitioningDelegate = self.transitionManager
            }
        } else if segue.identifier == self.redoLevelSegueIdentifier {
            let dest = segue.destinationViewController as? LoadingViewController
            dest?.songName = songName
            dest?.difficulty = difficulty
        } else if segue.identifier == self.nextLevelSegueIdentifier {
            let dest = segue.destinationViewController as? LoadingViewController
            var indexOfSong = songNames.indexOf(songName)
            let numSongs = songNames.count
            
            if indexOfSong!+1 < numSongs {
                dest?.songName = songNames[indexOfSong!+1]
                dest?.difficulty = difficulty
            }
            else {
                indexOfSong = 0
                dest?.songName = songNames[indexOfSong!]
                dest?.difficulty = difficulty
            }
        } else if segue.identifier == self.changeDifficultySegueIdentifier {
            if let difficultyViewController = segue.destinationViewController as? DifficultyViewController {
                difficultyViewController.songName = songName
            }
        }
        
    }


    // MARK: Animation
    private func animateSegueTransition(sender: UIButton, segueIdentifier: String) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(segueIdentifier, sender: sender)})
    }


    // MARK: Helpers
    private func setFinishedTrackStatus() {
        if !didFinishTrackSuccessfully {
            gameStateLabel.text = failText
            gameStateLabel.textColor = failTextColor
            return
        }
        gameStateLabel.text = successText
        gameStateLabel.font = gameStateLabel.font.fontWithSize(15)
        gameStateLabel.textColor = successTextColor
    }

    private func decorateButtons() {
        homeButton.layer.cornerRadius = 5
        redoButton.layer.cornerRadius = 5
        nextLevelButton.layer.cornerRadius = 5
        changeDifficultyButton.layer.cornerRadius = 5
    }

}
