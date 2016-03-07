//
//  AudioAnalyzer.h
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

@interface AudioAnalyzer : NSObject

/* Initialize and open an audio file */
- (id)init: (NSString*) audioFile;

/* Returns the opened track's duration in seconds */
- (float)getTrackDurationInSeconds;

/*
 @param audioFile The audio file path. The path will be searched from NSBundle mainBundle
 Returns true on success
 */
- (bool)open: (NSString*) audioFile;

@end
