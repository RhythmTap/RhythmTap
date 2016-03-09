//
//  HomeViewController.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var levelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        startButton.layer.cornerRadius = 5
        levelButton.layer.cornerRadius = 5
    }

}

