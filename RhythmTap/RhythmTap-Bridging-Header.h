#import <Foundation/Foundation.h>

/* This interface can be used in Swift */


/* Audio Standards */
/* The standard sample rate for MP3 and WAV formats */
static unsigned int DefaultSampleRate = 44100;



@interface AdvancedAudioPlayer: NSObject

/* Returns true if the audio IS playing */
- (bool) playAudio: (NSString*) audioFile;

/* Returns true if the audio is NOT playing */
- (bool) pauseAudio;

/* Prepare the audio player */
- (void) prepareAudioPlayer;

@end



@interface AudioAnalyzer : NSObject

@end