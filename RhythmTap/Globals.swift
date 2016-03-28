//
//  Globals.swift
//  RhythmTap
//
//  Created by Jennifer Terpstra on 2016-03-28.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import Foundation

class Globals {
    
    static var songNames : [String] = [String]()
    private static var isLoaded: Bool = false
    
    static func loadSongs() {
        if(!isLoaded) {
            let fileManager = NSFileManager.defaultManager()
            let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(NSBundle.mainBundle().bundlePath + "/Tracks/")!
        
            var count = 0
        
            while let file = enumerator.nextObject() as! String? {
                if(file.hasSuffix(".wav")) {
                    songNames.append(file.stringByReplacingOccurrencesOfString(".wav", withString: ""))
                    print(songNames[count])            }
                else if(file.hasSuffix(".mp3")) {
                    songNames.append(file.stringByReplacingOccurrencesOfString(".mp3", withString: ""))
                    print(songNames[count])
                }
                else {
                    songNames.append(file)
                    print(songNames[count])
                }
                count += 1
            }
        }
        isLoaded = true
    }
    
}