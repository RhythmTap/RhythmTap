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

class ScoreViewController: UIViewController {
    
    var correctTaps: Float = 0
    var incorrectTaps: Float = 0
    var tapAccuracy: Float!
    var score: Float!
    
    let transitionManager = TransitionManager()

    @IBOutlet weak var showNewHighScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var correctTapsLabel: UILabel!
    @IBOutlet weak var incorrectTapsLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    
    let managedContext = (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    var scores = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.tag = 1
        score = tapAccuracy
        
        showNewHighScoreLabel.hidden = true
        
        accuracyLabel.text = String(tapAccuracy) + "%"
        correctTapsLabel.text = String(Int(correctTaps))
        incorrectTapsLabel.text = String(Int(incorrectTaps))
        
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

    @IBAction func shake(sender: UIButton) {
        var segueName = ""
        if sender.tag == 1 {
            segueName = "backToHome"
        }
        
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
            }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(segueName, sender: sender)})
    }
    
    // establishes a new high score for this level and difficulty
    func newHighScore(scoreObject: NSManagedObject) {
        print("New high score!" + String(score))
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
        newScore.setValue(1, forKey: "level")   // set level
        newScore.setValue("easy", forKey: "difficulty") // set difficulty
        
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
        
        // search for the value
        let predicate = NSPredicate(format: "level = %i AND difficulty = %@", 1, "easy")
        
        // filter results accordingly
        var searchScores = entries.filteredArrayUsingPredicate(predicate)
        if searchScores.count != 0 {    // if there exists a score, update
            return searchScores[0]
        }
        else {  // otherwise, return nothing
            return ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.transitionManager.presenting = false
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
    }

}
