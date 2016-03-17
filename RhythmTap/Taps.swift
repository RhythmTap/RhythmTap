//
//  Taps.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-02-22.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class Taps {
    
    private var count: UInt!
    
    init() {
        count = 0
    }
    
    func increaseCount() {
        count = count + 1
    }
    
    func getCount() -> UInt {
        return count
    }
    
}