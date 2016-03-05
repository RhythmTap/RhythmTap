//
//  AudioProcessorTests.m
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-05.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "RhythmTap-Bridging-Header.h"

@interface AudioProcessorTests : XCTestCase

@property (nonatomic) AudioProcessor *audioProcessor;
@property NSString *audioFile;

@end



@implementation AudioProcessorTests

- (void)setUp {
    [super setUp];
    self.audioProcessor = [[AudioProcessor alloc] init];
    self.audioFile =  @"Tracks/Easy";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatAudioCanBePlayed {
    XCTAssertTrue([self.audioProcessor playAudio:self.audioFile]);
}

- (void)testThatAudioCanBePaused {
    [self.audioProcessor playAudio:self.audioFile];
    
    XCTAssertTrue([self.audioProcessor pauseAudio]);
}

@end
