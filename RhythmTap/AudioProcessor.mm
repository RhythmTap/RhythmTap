//
//  AudioProcessor.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-04.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <pthread.h>
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredAnalyzer.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredSimple.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AudioProcessor

// Private members
id<SuperpoweredIOSAudioIODelegate>delegate;
SuperpoweredIOSAudioIO *output;
SuperpoweredAdvancedAudioPlayer *player;
SuperpoweredOfflineAnalyzer *analyzer;
SuperpoweredAdvancedAudioPlayerCallback playerEventCallback;

float *stereoBuffer;
float volume = 1.0f;
double masterBpm = 0.0f;
double masterMsElapsedSinceLastBeat = -1.0;
unsigned int lastSamplerate = 0;
float bpm;
int lengthSeconds;
int cachedPointCount = 0;


/* Constructor */
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    // Allocate memory for our stereo buffer
    if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
    
    // The standard sample rate for MP3 and WAV formats
    unsigned int defaultSamplerate = 44100;
    
    // SuperPoweredAnalyzer is not an Obj-C class, so it needs to be instantiated like in C++
    // analyzer = new SuperpoweredOfflineAnalyzer(defaultSamplerate, bpm, lengthSeconds);
    
    // Use __bridge allocation so that this instance is not collected by ARC
    player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, defaultSamplerate, cachedPointCount);
    
    return self;
}

/* Destructor */
- (void) dealloc {
    delete analyzer;
    delete player;
    free(stereoBuffer);
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
    return player->playing ? false : true;
}

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
- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
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
    bool silence = !player->process(stereoBuffer, false, numberOfSamples, volume, masterBpm, player->msElapsedSinceLastBeat);
    
    // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    // Think of each buffer as the left and right speaker of your device
    SuperpoweredDeInterleave(stereoBuffer, buffers[0], buffers[1], numberOfSamples);
    
    return !silence;
}

@end
