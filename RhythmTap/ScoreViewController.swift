//
//  ScoreViewController.swift
//  RhythmTap
//
//  Created by Jennifer Terpstra on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    var correctTaps: Float = 0
    var incorrectTaps: Float = 0

    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var correctTapsLabel: UILabel!
    @IBOutlet weak var incorrectTapsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Accuracy is currently not valid, need to have expected taps value. Placeholder for now
        accuracyLabel.text = String(correctTaps) + "%"
        correctTapsLabel.text = String(Int(correctTaps))
        incorrectTapsLabel.text = String(Int(incorrectTaps))
        
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
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
