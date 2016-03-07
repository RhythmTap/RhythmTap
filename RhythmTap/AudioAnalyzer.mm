//
//  AudioAnalyzer.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SuperpoweredDecoder.h"
#import "SuperpoweredAnalyzer.h"

#import "AudioAnalyzer.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AudioAnalyzer {
    /* Processes audio */
    SuperpoweredOfflineAnalyzer *analyzer;
    
    /* Extracts meta data from audio files */
    SuperpoweredDecoder *decoder;
}

/* Constructor */
- (id)init: (NSString*) audioFile {
    self = [super init];
    if (!self) return nil;
    
    /* Used to extract meta*/
    decoder = new SuperpoweredDecoder();
    
    bool isAudioFileOpened = [self open:audioFile];
    if (!isAudioFileOpened) {
        NSLog(@"AudioAnalyzer Warning: Could not open audio file!");
    }
    
    

    return self;
}

/* Destructor - Clean up memory */
- (void) dealloc {
    delete analyzer;
}

/* Interface */
- (float)getTrackDurationInSeconds {
    return decoder->durationSeconds;
}

- (bool)open:(NSString *)audioFile {
    NSString *fullpathToFile = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"wav"];
    const char *result = decoder->open([fullpathToFile cStringUsingEncoding:NSUTF8StringEncoding]);
    if (result == NULL) {
        return true;
    }
    return false;
}

/* Get the BPM for a given audio file */
- (float) getBpm: (NSString*) audioFile {
    return 1.0f;
}

/* Private Interface */

/* Returns true if the source's length in seconds > 0 */
- (bool) analyze {
    if (decoder) {
        /* Must be 0 to detect the track's bpm */
        float detectBpm = 0;
        analyzer = new SuperpoweredOfflineAnalyzer(DefaultSampleRate, detectBpm, decoder->durationSeconds);
        //https://github.com/superpoweredSDK/Low-Latency-Android-Audio-iOS-Audio-Engine/blob/master/SuperpoweredOfflineProcessingExample/SuperpoweredOfflineProcessingExample/ViewController.mm
        return true;
    }
    return false;
}

@end
