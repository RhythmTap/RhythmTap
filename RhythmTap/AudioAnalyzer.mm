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
#import "RhythmTap-Bridging-Header.h"

@implementation AudioAnalyzer {
    SuperpoweredOfflineAnalyzer *analyzer;
    SuperpoweredDecoder *decoder;
}

/* Constructor */
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    decoder = new SuperpoweredDecoder();
    
    /* This must be set to 0 to detect the track's bpm */
    float detectBpm = 0;
    
    /* Need the source's length in seconds */
    int sourceLengthInSeconds = 0;
    analyzer = new SuperpoweredOfflineAnalyzer(DefaultSampleRate, detectBpm, sourceLengthInSeconds);

    return self;
}

/* Interface */
- (float)getTrackDurationInSeconds {
    return decoder->durationSeconds;
}


/* Private Interface */
- (bool)open:(NSString *)audioFile {
    NSString *fullpathToFile = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"wav"];
    const char *result = decoder->open([fullpathToFile cStringUsingEncoding:NSUTF8StringEncoding]);
    if (result == NULL) {
        return true;
    }
    return false;
}

@end
