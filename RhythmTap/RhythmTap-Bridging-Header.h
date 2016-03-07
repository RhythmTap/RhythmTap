#import <Foundation/Foundation.h>
#import "AudioTrack.h"
#import "AudioAnalyzer.h"

/* This interface can be used in Swift */


/* Audio Standards */
/* The standard sample rate in KHz for MP3 and WAV formats */
static unsigned int DefaultSampleRate = 44100;



@interface AdvancedAudioPlayer: NSObject

/* Returns true if the audio IS playing */
- (bool)playAudio: (AudioTrack*)audioTrack;

/* Returns true if the audio is NOT playing */
- (bool)pauseAudio;

/* Prepare the audio player
 @param bpm The track's bpm
 */
- (void)prepareAudioPlayer: (AudioTrack*)audioTrack;

- (void)dealloc;

@end



