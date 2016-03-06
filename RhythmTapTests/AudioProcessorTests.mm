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

@property (nonatomic) AdvancedAudioPlayer *advancedAudioPlayer;
@property NSString *audioFile;

@end



@implementation AdvancedAudioPlayerTests

- (void)setUp {
    [super setUp];
    self.advancedAudioPlayer = [[AdvancedAudioPlayer alloc] init];
    self.audioFile =  @"Tracks/Easy";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatAudioCanBePlayed {
    XCTAssertTrue([self.advancedAudioPlayer playAudio:self.audioFile]);
}

- (void)testThatAudioCanBePaused {
    [self.advancedAudioPlayer playAudio:self.audioFile];
    
    XCTAssertTrue([self.advancedAudioPlayer pauseAudio]);
}

@end
