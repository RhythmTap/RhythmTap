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
    var songName: String!
    var audioFormat: String!
    
    override init() {
        self.songName = "";
        self.audioFormat = "";
    }
    
    init(songName: String, audioFormat: String) {
        self.songName = songName
        self.audioFormat = audioFormat
    }
    
    func getFullBundlePath() -> String {
        if let fullpathToFile = NSBundle.mainBundle().pathForResource(songName, ofType:audioFormat) {
            return fullpathToFile
        }
        return "Could not find " + songName + "." + audioFormat + " in main bundle"
    }

}
