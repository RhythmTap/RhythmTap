//
//  Globals.swift
//  RhythmTap
//
//  Created by Jennifer Terpstra on 2016-03-28.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class Globals {

    static var tracks: [AudioTrack] = [AudioTrack]()
    private static var isLoaded: Bool = false
    
    static func loadSongs() {
        if(!isLoaded) {
            let fileManager = NSFileManager.defaultManager()
            let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(NSBundle.mainBundle().bundlePath + "/Tracks/")!
        
            while let file = enumerator.nextObject() as! String? {
                let stringTokens = file.componentsSeparatedByString(".")
                let songName = Config.TrackDirectory + stringTokens[0]
                let format = stringTokens[1]
                let audioTrack = AudioTrack(songName: songName, audioFormat: format)
                tracks.append(audioTrack)
                print(audioTrack.songName)
            }
        }
        isLoaded = true
    }
    
}