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

    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var correctTapsLabel: UILabel!
    @IBOutlet weak var incorrectTapsLabel: UILabel!
    
    let managedContext = (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    var scores = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Accuracy is currently not valid, need to have expected taps value. Placeholder for now
        accuracyLabel.text = String(correctTaps) + "%"
        correctTapsLabel.text = String(Int(correctTaps))
        incorrectTapsLabel.text = String(Int(incorrectTaps))
        
        let fetchRequest = NSFetchRequest(entityName: "Score")
        do {
            // fetch scores into results
            let results = try managedContext.executeFetchRequest(fetchRequest)
            scores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.navigationItem.hidesBackButton = true
        print(scores)
        //newHighScore()
        getHighScore()
        
    }

    func newHighScore() {
        let pastScore =  NSEntityDescription.entityForName("Score", inManagedObjectContext:managedContext)
        let newScore = NSManagedObject(entity: pastScore!, insertIntoManagedObjectContext: managedContext)
        newScore.setValue(correctTaps, forKey: "highScore")
        newScore.setValue(1, forKey: "level")
        newScore.setValue("easy", forKey: "difficulty")
        
        //4
        do {
            try managedContext.save()
            //5
            scores.append(newScore)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getHighScore() {
        let entries : NSArray = scores
        
        // search for the value in name or country
        let predicate = NSPredicate(format: "level = %@ AND difficulty = %@", 1, "easy")
        
        // filter results accordingly
        var searchScores = entries.filteredArrayUsingPredicate(predicate)
        print(searchScores[0])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
