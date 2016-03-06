//
//  AdvancedAudioPlayer.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-04.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredAnalyzer.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AdvancedAudioPlayer {
    
    /* The IO buffer so that we can actually hear the audio */
    SuperpoweredIOSAudioIO *output;
    
    /* The audio player */
    SuperpoweredAdvancedAudioPlayer *player;
    
    /* A callback to recive events from the audio player */
    SuperpoweredAdvancedAudioPlayerCallback playerEventCallback;
    
    
    float *stereoBuffer;
    float volume;
    double masterBpm;
    double masterMsElapsedSinceLastBeat;
    unsigned int lastSamplerate;
    unsigned int defaultSamplerate;
    float bpm;
    int lengthSeconds;
    int cachedPointCount;
}



/* Constructor */
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self->volume = 1.0f;
    self->masterBpm = 0.0f;
    self->masterMsElapsedSinceLastBeat = -1.0;
    self->lastSamplerate = 0;
    self->cachedPointCount = 0;
    
    self->defaultSamplerate = 44100;
    
    // Allocate memory for our stereo buffer
    if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
    
    // Use __bridge allocation so that this instance is not collected by ARC
    player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, self->defaultSamplerate, cachedPointCount);
    
    return self;
}

/* Destructor - Clean up memory */
- (void) dealloc {
    delete self->player;
    free(self->stereoBuffer);
    output = nil;
    NSLog(@"The memory should be free now!");
}

/* Play the audio */
- (bool) playAudio: (NSString*)audioFile {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"wav"];
    player->open([fullPath fileSystemRepresentation]);
    [self prepareIO];
    
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
- (void) prepareAudioPlayer {
    player->setBpm(126.0f);
    player->setFirstBeatMs(353);
    player->setPosition(player->firstBeatMs, false, false);
}

/* Prepare the audio IO for playback */
- (void) prepareIO {
    output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2];
    [output start];
}


/* SuperpoweredIOSAudioDelegate Implementation */
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
    
    // Let the audio player process the audio
    // TODO The problem is the following:
    // Play -> Good!
    // Then, we tap play again; this time, the buffer is not here!
    
    // Maybe put a lock here?
    
    bool silence = !player->process(stereoBuffer, false, numberOfSamples, volume, masterBpm, player->msElapsedSinceLastBeat);
    
    // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    // Think of each buffer as the left and right speaker of your device
    SuperpoweredDeInterleave(stereoBuffer, buffers[0], buffers[1], numberOfSamples);
    
    return !silence;
}

@end
