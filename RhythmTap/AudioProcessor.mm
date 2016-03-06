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
#import "RhythmTap-Bridging-Header.h"

@implementation AudioProcessor

// Private members
id<SuperpoweredIOSAudioIODelegate>delegate;
SuperpoweredIOSAudioIO *output;
SuperpoweredAdvancedAudioPlayer *player;
SuperpoweredOfflineAnalyzer *analyzer;
SuperpoweredAdvancedAudioPlayerCallback playerEventCallback;

pthread_mutex_t mutex;
unsigned int samplerate;
float bpm;
int lengthSeconds;
int cachedPointCount = 4;

- (id)init {
    self = [super init];
    if (!self) return nil;

    // The standard sample rate for MP3 and WAV formats
    samplerate = 44100;
    
    
    // We use a mutex to prevent simultaneous reading/writing of bands.
    pthread_mutex_init(&mutex, NULL);
    
    // SuperPoweredAnalyzer is not an Obj-C class, so it needs to be instantiated like in C++
    analyzer = new SuperpoweredOfflineAnalyzer(samplerate, bpm, lengthSeconds);
    
    // Use __bridge allocation so that this instance is not collected by ARC
    player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, samplerate, 0);
    
    return self;
}


- (void) dealloc {
    delete analyzer;
    delete player;
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
    return true;
}

@end
