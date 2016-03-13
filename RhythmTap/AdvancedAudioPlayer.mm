//
//  AdvancedAudioPlayer.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-04.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"

#import "RhythmTap-Swift.h"


@implementation AdvancedAudioPlayer {
    
    /* The IO buffer so that we can actually hear the audio */
    SuperpoweredIOSAudioIO *output;
    
    /* The audio player */
    SuperpoweredAdvancedAudioPlayer *player;
    
    float *stereoBuffer;
    float volume;
    double masterBpm;
    double masterMsElapsedSinceLastBeat;
    unsigned int lastSamplerate;
    int lengthSeconds;
    int cachedPointCount;
}

/* Handle when the player finishes playing the track */
static void playerEventCallback(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    AdvancedAudioPlayer *self = (__bridge AdvancedAudioPlayer *)clientData;
    if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
        NSLog(@"AdvancedAudioPlayer is ready");
    } else if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadError) {
        NSLog(@"AvancedAudioPlayer failed to load");
    } else if (event == SuperpoweredAdvancedAudioPlayerEvent_EOF && !self->player->looping) {
        NSLog(@"AvancedAudioPlayer finished playing song");
        bool isAudioPaused = self.pauseAudio;
        if (!isAudioPaused) {
            NSLog(@"Failed to pause audio!");
            return;
        }
        if (self->_delegate) {
            // A ViewController implements the delegate, which means that changes will possibly be made to the UI
            // It is best to keep all UI functionality on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_delegate onTrackFinish];
            });
        }
    }
}

/**** Constructor ****/
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self->volume = 1.0f;
    self->masterBpm = 0.0f;
    self->masterMsElapsedSinceLastBeat = -1.0;
    self->lastSamplerate = 0;
    self->cachedPointCount = 0;
    
    // Allocate memory for our stereo buffer
    if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
    
    // Use __bridge allocation so that this instance is not collected by ARC
    player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, DefaultSampleRate, cachedPointCount);
    
    return self;
}

/**** Destructor - Clean up memory ****/
- (void) dealloc {
    delete self->player;
    free(self->stereoBuffer);
    output = nil;
    NSLog(@"The memory should be free now!");
}

/* Play the audio */
- (bool) playAudio {
    bool synchronised = false;
    player->play(synchronised);
    return player->playing;
}

/* Pause the audio player */
- (bool) pauseAudio {
    player->pause();
    [output stop];
    return player->playing ? false : true;
}

/* Prepare the audio player */
- (void) prepareAudioPlayer: (id<AudioAnalyzerDelegate>)delegate audioTrackToPrepare:(AudioTrack*)audioTrack {
    NSString *fullPath = [audioTrack getFullBundlePath];
    player->open([fullPath fileSystemRepresentation]);
    
    // For some reason, the analyzer must be in the same scope as the callback block :/
    AudioAnalyzer *analyzer = [[AudioAnalyzer alloc] init:audioTrack];
    
    // Set the delegate so that we can call back to the caller
    analyzer.delegate = delegate;
    
    
    /* This needs to be pushed to a background thread so that the main thread's resources
       are not consumed by audio processing computations. This allows UI tasks to still be
       active, such as loading a progress bar. */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        void(^callback)(float) = ^void(float bpm){
            
            double closestBeatMs = player->closestBeatMs(0, 0);
            self->masterBpm = bpm;
            bool stopPlayback = true;
            player->setBpm(bpm);
            player->setFirstBeatMs(closestBeatMs);
            player->setPosition(player->firstBeatMs, stopPlayback, false);
            player->fixDoubleOrHalfBPM = true;
            
            // All SuperpoweredIO functions should be executed on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareIO];
            });
            
            // Callback to the delegate because the analyzer has finished processing the BPM
            [analyzer.delegate doneFetchingBpm];
        };
        
        [analyzer asyncProcessBpm:callback];
    });

}

/* Prepare the audio IO for playback */
- (void) prepareIO {
    output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2];
    [output start];
}

/**** SuperpoweredIOSAudioDelegate Implementation ****/
- (void)interruptionStarted {
    NSLog(@"Audio Player Interrupted!");
}
- (void)recordPermissionRefused {
    NSLog(@"Record Permission Refused!");
}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}

- (void)interruptionEnded { // If a player plays Apple Lossless audio files, then we need this. Otherwise unnecessary.
    player->onMediaserverInterrupt();
}

// This is where the Superpowered magic happens.
- (bool)audioProcessingCallback:(float **)buffers inputChannels:(unsigned int)inputChannels outputChannels:(unsigned int)outputChannels numberOfSamples:(unsigned int)numberOfSamples samplerate:(unsigned int)samplerate hostTime:(UInt64)hostTime {
    if (samplerate != lastSamplerate) { // Has samplerate changed?
        lastSamplerate = samplerate;
        player->setSamplerate(samplerate);
    };
    
    bool silence = !player->process(stereoBuffer, false, numberOfSamples, volume, masterBpm, player->msElapsedSinceLastBeat);
    
    // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    // Think of each buffer as the left and right speaker of your device
    SuperpoweredDeInterleave(stereoBuffer, buffers[0], buffers[1], numberOfSamples);

    return !silence;
}

/* Properties */
/* Indicates if the player is playing or paused */
- (bool)isPlaying {
    return player->playing;
}

/* The actual bpm of the track (as bpm changes with the current tempo)*/
- (double)getCurrentBpm {
    return player->currentBpm;
}

/* Which beat has just happened (1 [1.0f-1.999f], 2 [2.0f-2.999f], 3 [3.0f-3.99f], 4 [4.0f-4.99f]). A value of 0 means "don't know". */
- (float)getBeatIndex {
    return player->beatIndex;
}

/* Tells where the first beat (the beatgrid) begins. Must be correct for syncing. */
- (double)getFirstBeatMs {
    return player->firstBeatMs;
}


/* Developer Diagnostics */
- (void) logBeats {
    if (ceil(player->beatIndex)) {
        NSLog(@"Current BPM: %f", player->currentBpm);
        NSLog(@"Current Beat Index: %f", player->beatIndex);
    }
}

@end