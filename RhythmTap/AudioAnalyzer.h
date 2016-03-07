//
//  AudioAnalyzer.h
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import "AudioTrack.h"

@interface AudioAnalyzer : NSObject

/* Use this for the progress bar in the UI when analyzing audio */
@property double progress;

/* The audio track that is being analyzed */
@property AudioTrack *audioTrack;


/* Initialize and open an audio file */
- (id)init: (AudioTrack*) audioFile;

/* Returns the opened track's duration in seconds */
- (float)getTrackDurationInSeconds;

/* Returns the audio track's BPM on success and 0 on failure */
- (float)getBpm;

@end
