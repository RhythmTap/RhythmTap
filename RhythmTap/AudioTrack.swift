//
//  AudioTrack.swift
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-09.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

@objc public class AudioTrack : NSObject {
    
    // MARK: Properties
    var file: String!
    var audioFormat: String!
    
    override init() {
        self.file = "";
        self.audioFormat = "";
    }
    
    init(file: String, audioFormat: String) {
        self.file = file
        self.audioFormat = audioFormat
    }
    
}
