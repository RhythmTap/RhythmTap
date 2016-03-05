#import <Foundation/Foundation.h>

@interface AudioProcessor: NSObject

- (void)processAudio;

- (bool)playAudio: (NSString*)audioFile;

@end