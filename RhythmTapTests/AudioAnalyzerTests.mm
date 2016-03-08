//
//  AudioAnalyzerTests.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SuperpoweredDecoder.h"
#import "AudioAnalyzer.h"

@interface AudioAnalyzerTests : XCTestCase
@property AudioAnalyzer *analyzer;
@property AudioTrack *audioTrack;
@end

@implementation AudioAnalyzerTests

- (void)setUp {
    [super setUp];
    NSString *file = @"Tracks/Easy";
    NSString *audioFormat = @"wav";
    self.audioTrack =  [[AudioTrack alloc] init:file audioFormat:audioFormat];
    self.analyzer = [[AudioAnalyzer alloc] init:self.audioTrack];
}

- (void)tearDown {
    [super tearDown];
    self.analyzer = nil;
    self.audioTrack = nil;
}

- (void)testDefaultTrackDurationCanBeFetched {
    float expectedTrackDuration = 8.00f;
    
    XCTAssertEqual(self.analyzer.getTrackDurationInSeconds, expectedTrackDuration);
}

- (void)testThatBpmCanBeFetched {
    float expectedBpm = 120.0f;
    XCTAssertEqual([self.analyzer getBpm], expectedBpm);
}



@end
