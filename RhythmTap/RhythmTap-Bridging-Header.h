#import <Foundation/Foundation.h>
#ifdef __cplusplus
# include "SuperpoweredAdvancedAudioPlayer.h"
#endif

@interface AudioProcessor: NSObject

/* Returns true if the audio IS playing */
- (bool) playAudio: (NSString*) audioFile;

/* Returns true if the audio is NOT playing */
- (bool) pauseAudio;

- (void) prepareAudioPlayer;

@end