//
//  AudioAnalyzer.h
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import "AudioTrack.h"


@protocol AudioAnalyzerDelegate <NSObject>

/* Called when BPM is completely analyzed */
- (void)doneFetchingBpm;

/* Called every time a sample is processed when analyzing BPM */
- (void)onFetchBpm: (double)decodedSamples finishPosition:(double)totalSamples;

@end


@interface AudioAnalyzer : NSObject

/**** Properties ****/
@property (nonatomic, weak) id<AudioAnalyzerDelegate> delegate;

/* The audio track that is being analyzed */
@property AudioTrack *audioTrack;



/* Initialize and open an audio file */
- (id)init: (AudioTrack*) audioFile;

/* Processes the audio track's BPM on success and 0 on failure
   @param callback A callback function that accepts the processed BPM as a parameter
 */
- (void)asyncProcessBpm: (void(^)(float bpm))callback;

/* Returns the opened track's duration in seconds */
- (float)getTrackDurationInSeconds;

/* Open the provided audio track for analysis */
- (bool)open: (AudioTrack*)audioTrack;

@end
