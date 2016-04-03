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
#import "SuperpoweredSimple.h"

#import "RhythmTap-Swift.h"
#import "RhythmTap-Bridging-Header.h"


@implementation AudioAnalyzer {
    /* Processes audio */
    SuperpoweredOfflineAnalyzer *analyzer;
    
    /* Extracts meta data from audio files */
    SuperpoweredDecoder *decoder;
}

/* Constructor */
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    /* Used to extract metadata */
    decoder = new SuperpoweredDecoder();
    
    /* Must be 0 to detect the track's bpm */
    float detectBpm = 0;
    analyzer = new SuperpoweredOfflineAnalyzer(DefaultSampleRate, detectBpm, decoder->durationSeconds);
    
    return self;
}

/* Same as default constructor, except that it also opens the provided audio track
   @param audioTrack The audio track to analyze
 */
- (id)init: (AudioTrack*) audioTrack {
    self = [super init];
    if (!self) return nil;
    
    /* Used to extract metadata */
    decoder = new SuperpoweredDecoder();
    
    NSLog(@"AudioTrack: %@ %@", audioTrack.songName, audioTrack.audioFormat);
    
    bool isAudioFileOpened = [self open:audioTrack];
    if (!isAudioFileOpened) {
        NSLog(@"AudioAnalyzer Warning: Could not open audio file!");
    }
        
    /* Must be 0 to detect the track's bpm */
    float detectBpm = 0;
    analyzer = new SuperpoweredOfflineAnalyzer(DefaultSampleRate, detectBpm, decoder->durationSeconds);
    
    return self;
}



/* Destructor - Clean up memory */
- (void) dealloc {
    delete decoder;
    delete analyzer;
}

/* Interface */
- (float)getTrackDurationInSeconds {
    // Let the decoder open the audio track
    if (![self open:self->_audioTrack]) {
        NSLog(@"Could not open audio track");
        return 0.0f;
    }
    return decoder->durationSeconds;
}

/* Get the BPM for a given audio file */
- (void)asyncProcessBpm: (void(^)(float bpm))callback {
    
    // Let the decoder open the audio track
    if (![self open:self->_audioTrack]) {
        NSLog(@"Could not open audio track");
    }
    
    // Create a buffer for the 16-bit integer samples coming from the decoder.
    short int *intBuffer = (short int *)malloc(decoder->samplesPerFrame * 2 * sizeof(short int) + 16384);
    // Create a buffer for the 32-bit floating point samples required for the analyzer.
    float *floatBuffer = (float *)malloc(decoder->samplesPerFrame * 2 * sizeof(float) + 1024);
    
    // Processing
    while (true) {
        // Decode one frame. samplesDecoded will be overwritten with the actual decoded number of samples.
        unsigned int samplesDecoded = decoder->samplesPerFrame;
        if (decoder->decode(intBuffer, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) break;
        if (samplesDecoded < 1) break;
        
        // Convert the decoded PCM samples from 16-bit integer to 32-bit floating point.
        SuperpoweredShortIntToFloat(intBuffer, floatBuffer, samplesDecoded);
        
        // Analyze the sample
        analyzer->process(floatBuffer, samplesDecoded);
        
        // Update the progress indicator on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate onFetchBpm:decoder->samplePosition finishPosition:decoder->durationSamples];
        });
    }
    
    // Callback to alert that BPM processing is done on the main thread
    // It is now safe to read the BPM
    dispatch_async(dispatch_get_main_queue(), ^{
        // Use bpm as an input argument
        float bpm;
        analyzer->getresults(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &bpm, NULL, NULL);
        
        // Clean up memory
        free(intBuffer);
        free(floatBuffer);
        
        callback(bpm);
    });
}

- (bool)open:(AudioTrack*)audioTrack {
    self->_audioTrack = audioTrack;
    NSString *fullpathToFile = [audioTrack getFullBundlePath];
    const char *result = decoder->open([fullpathToFile cStringUsingEncoding:NSUTF8StringEncoding]);
    if (result == NULL) {
        return true;
    }
    return false;
}

@end
