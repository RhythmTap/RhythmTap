//
//  AudioAnalyzer.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperpoweredAnalyzer.h"
#import "RhythmTap-Bridging-Header.h"

@implementation AudioAnalyzer {
    SuperpoweredOfflineAnalyzer *analyzer;
}

/* Constructor */
- (id)init {
    
    /* This must be set to 0 to detect the track's bpm */
    float detectBpm = 0;
    
    /* Need the source's length in seconds */
    int sourceLengthInSeconds = 0;
    analyzer = new SuperpoweredOfflineAnalyzer(DefaultSampleRate, detectBpm, sourceLengthInSeconds);

    return self;
}

@end
