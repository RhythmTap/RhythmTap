//
//  HomeViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class HomeViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var rhythmTap: UILabel!

    let transitionManager = TransitionManager()
    let loadingViewSegueIdentifier = "loadingViewSegue"
    let chooseLevelSegueIdentifier = "levelViewSegue"
    let difficulty = Difficulty.Easy
    let defaultSongName = "Easy"
    
    var level: Int!

    var songName: String!
    var songNames : [String] = [String]()

    let managedContext = (UIApplication.sharedApplication().delegate as!
        AppDelegate).managedObjectContext
    var scores = [NSManagedObject]()

    // MARK: View handling
    override func viewDidLoad() {
        super.viewDidLoad()
        Globals.loadSongs()
        decorateButtons()
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
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: false)]
            fetchRequest.fetchLimit = 1
            let results = try managedContext.executeFetchRequest(fetchRequest)
            scores = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } catch {
            print("Failed to fetch request")
        }
        if scores.count > 0 {
            print("Highest level played: " + String(scores[0].valueForKey("level")!))
            level = scores[0].valueForKey("level") as! Int
            if level >= songNames.count {
                level = 1
            }
            else {
                level = level + 1
            }
        }
        else {
            level = 1
        }
        print(level)
        songName = songNames[level - 1]
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

    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.transitionManager.presenting = false
        if segue.identifier == loadingViewSegueIdentifier {
            if let loadingViewController = segue.destinationViewController as? LoadingViewController {
                loadingViewController.difficulty = difficulty
                loadingViewController.songName = songName
                loadingViewController.transitioningDelegate = self.transitionManager
            }
            return
        }
        if segue.identifier == self.chooseLevelSegueIdentifier {
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
    }


    private func animateSegueTransition(segueName: String, sender: UIButton) {
        let bounds = sender.bounds
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: {(finished: Bool) -> Void in self.performSegueWithIdentifier(segueName, sender: sender)})
    }

}

