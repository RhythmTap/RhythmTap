//
//  AdvancedAudioPlayer.h
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-07.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AudioTrack.h"



@protocol AdvancedAudioPlayerDelegate <NSObject>

/* Invoked as soon as the track finishes playing */
- (void) onTrackFinish;

@end



@interface AdvancedAudioPlayer: NSObject

/* Object conforming to protocol must be of type UIViewController */
@property (nonatomic, weak) UIViewController <AdvancedAudioPlayerDelegate>* delegate;


/* Returns true if the audio IS playing */
- (bool)playAudio;

/* Returns true if the audio is NOT playing */
- (bool)pauseAudio;

/* Prepare the audio player
 @param bpm The track's bpm
 */
- (void)prepareAudioPlayer: (AudioTrack*)audioTrack;



/***** Properties *****/

/* Indicates if the player is playing or paused */
- (bool)isPlaying;

/* The actual bpm of the track (as bpm changes with the current tempo)*/
- (double)getCurrentBpm;

/* Tells where the first beat (the beatgrid) begins. Must be correct for syncing. */
- (double)getFirstBeatMs;

/* Which beat has just happened (1 [1.0f-1.999f], 2 [2.0f-2.999f], 3 [3.0f-3.99f], 4 [4.0f-4.99f]). A value of 0 means "don't know". */
- (float)getBeatIndex;

@end