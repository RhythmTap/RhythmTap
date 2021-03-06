//
//  ViewController.swift
//  RhythmTap
//
//  Created by Richard Sage on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class LevelViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var difficulty : Difficulty!
    var selectedSong = -1

    let difficultyViewSegueIdentifier = "difficultyViewSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.difficultyViewSegueIdentifier {
            if let difficultyView = segue.destinationViewController as? DifficultyViewController {
                if(selectedSong > -1) {
                    difficultyView.currentTrack = Globals.tracks[selectedSong]
                }
            }
        }
    }
    
    //number of cells
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Globals.tracks.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width/5, height: UIScreen.mainScreen().bounds.width/5);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    //creating the data cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelViewCell", forIndexPath: indexPath) as! LevelViewCell
        
        cell.levelSelect.setTitle( String(indexPath.item + 1), forState: UIControlState.Normal)
        cell.levelSelect.songNum = indexPath.item
        
        //format the cell
        formatDataCell(cell, indexPath: indexPath);
        
        cell.levelSelect.addTarget(self, action: "levelSelect:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell;
    }
    
    //formatting cell initially
    func formatDataCell(cell: LevelViewCell, indexPath: NSIndexPath) {
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = UIColor.clearColor().CGColor;
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 5;
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func levelSelect (sender : LevelButton!) {
        selectedSong = sender.songNum
        self.performSegueWithIdentifier(self.difficultyViewSegueIdentifier, sender: self)
    }
}
