//
//  ViewController.swift
//  RhythmTap
//
//  Created by Richard Sage on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class LevelViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var songNames : [String] = [String]()
    var difficulty : Difficulty!
    var selectedSong = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let loadView = segue.destinationViewController as! LoadingViewController
        if(selectedSong > -1) {
            print(songNames[selectedSong])
            loadView.songName = songNames[selectedSong]
        }
        loadView.difficulty = difficulty
    }
    
    //number of cells
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(NSBundle.mainBundle().bundlePath + "/Tracks/")!
        
        var count = 0
        
        while let file = enumerator.nextObject() as! String? {
            if(file.hasSuffix(".wav")) {
                songNames.append(file.stringByReplacingOccurrencesOfString(".wav", withString: ""))
                print(songNames[count])
                count++
            }
        }
        
        return count
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
        cell.layer.borderWidth = 2;
        cell.layer.borderColor = UIColor.blackColor().CGColor;
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 2;
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func levelSelect (sender : LevelButton!) {
        selectedSong = sender.songNum
        print(selectedSong)
        self.performSegueWithIdentifier("levelToGameSegue", sender: self)
    }
}
