#import <Foundation/Foundation.h>
#ifdef __cplusplus
# include "SuperpoweredAdvancedAudioPlayer.h"
#endif

@interface AudioProcessor: NSObject

- (void)processAudio;

- (bool)playAudio: (NSString*)audioFile;

- (void)prepareAudioPlayer;

@end