//
//  AdvancedAudioPlayerTests.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-05.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "RhythmTap-Bridging-Header.h"

@interface AdvancedAudioPlayerTests : XCTestCase

@property AdvancedAudioPlayer *advancedAudioPlayer;
@property AudioTrack *audioTrack;

@end



@implementation AdvancedAudioPlayerTests

- (void)setUp {
    [super setUp];
    NSString *file = @"Tracks/Easy";
    NSString *audioFormat = @"wav";
    self.audioTrack =  [[AudioTrack alloc] init:file audioFormat:audioFormat];
    self.advancedAudioPlayer = [[AdvancedAudioPlayer alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatAudioCanBePlayed {
    XCTAssertTrue([self.advancedAudioPlayer playAudio:self.audioTrack]);
}

- (void)testThatAudioCanBePaused {
    [self.advancedAudioPlayer playAudio:self.audioTrack];
    
    XCTAssertTrue([self.advancedAudioPlayer pauseAudio]);
}

@end
