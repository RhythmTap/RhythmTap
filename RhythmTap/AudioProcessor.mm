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
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AudioProcessor

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
    player = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallback, samplerate, 4);
    return self;
}



-(void) dealloc {
    delete analyzer;
}

-(bool) playAudio: (NSString*)audioFile {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"wav"];
    player->open([fullPath fileSystemRepresentation]);
    bool synchronised = false;
    player->play(synchronised);
    return player->playing;
}

-(void) prepareAudioPlayer {
    player->setBpm(126.0f);
    player->setFirstBeatMs(353);
    player->setPosition(player->firstBeatMs, false, false);
}

@end
