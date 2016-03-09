//
//  ViewController.swift
//  RhythmTap
//
//  Created by Richard Sage on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class LevelViewController: UICollectionViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //number of cells
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO return the number of songs in the app
        return 81
    }
    
    //creating the data cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelViewCell", forIndexPath: indexPath) as! LevelViewCell
        
        //format the cell
        formatDataCell(cell, indexPath: indexPath);
        
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
        //call segue to game view with selected level
    }
}
