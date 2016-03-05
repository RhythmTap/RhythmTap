//
//  AudioProcessor.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-04.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <pthread.h>
#import "SuperpoweredAnalyzer.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AudioProcessor

SuperpoweredOfflineAnalyzer *analyzer;
pthread_mutex_t mutex;
unsigned int samplerate;
float bpm;
int lengthSeconds;

- (id)init {
    self = [super init];
    if (!self) return nil;

    // The standard sample rate for MP3 and WAV formats
    samplerate = 44100;
    
    
    // We use a mutex to prevent simultaneous reading/writing of bands.
    pthread_mutex_init(&mutex, NULL);
    
    // SuperPoweredAnalyzer is not an Obj-C class, so it needs to be instantiated like in C++
    analyzer = new SuperpoweredOfflineAnalyzer(samplerate, bpm, lengthSeconds);
    
    return self;
}

-(void) processAudio {
    
}

@end