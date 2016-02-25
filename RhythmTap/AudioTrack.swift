//
//  AudioTrack.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-02-25.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class AudioTrack {
    
    // MARK: Properties
    var file: String!
    var audioFormat: String!
    
    
    // MARK: Initialization
    init() {
        self.audioFormat = ""
        self.file = ""
    }
    
    init(file: String, audioFormat: String) {
        self.file = file
        self.audioFormat = audioFormat
    }
}