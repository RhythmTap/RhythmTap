//
//  AudioAnalyzerTests.mm
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SuperpoweredDecoder.h"
#import "RhythmTap-Bridging-Header.h"

@interface AudioAnalyzerTests : XCTestCase
@property AudioAnalyzer *analyzer;
@property NSString *trackName;
@end

@implementation AudioAnalyzerTests

- (void)setUp {
    [super setUp];
    self.analyzer = [[AudioAnalyzer alloc] init];
    self.trackName = @"Tracks/Easy";
}

- (void)tearDown {
    [super tearDown];
    self.analyzer = nil;
}

- (void)testThatAudioCanBeOpened {
    XCTAssertTrue([self.analyzer open:(self.trackName)]);
}

- (void)testDefaultTrackDurationCanBeFetched {
    [self.analyzer open:self.trackName];
    float expectedTrackDuration = 8.00f;
    
    XCTAssertEqual(self.analyzer.getTrackDurationInSeconds, expectedTrackDuration);
}



@end
