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
@property XCTestExpectation *testThatBpmCanBeFetchedExpectation;
@property XCTestExpectation *testThatBpmCanBeFetchedDefaultConstructorExpectation;
@property XCTestExpectation *testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation;

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
    
    // Create the callback block
    void(^callback)(float bpm);
    callback = ^void(float bpm) {
        
        // Asynchronously fulfill the test expectation
        [self.testThatBpmCanBeFetchedExpectation fulfill];
        XCTAssertEqual(bpm, expectedBpm);
        
    };
    
    // Set the expectation timer
    self.testThatBpmCanBeFetchedExpectation = [self expectationWithDescription:@"BPM should have been set"];
    
    // Asynchronously process the BPM
    [self.analyzer asyncProcessBpm:callback];
    
    // If we timeout, something went wrong
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testThatBpmCanBeFetchedDefaultConstructor {
    AudioAnalyzer *analyzer = [[AudioAnalyzer alloc] init];
    [analyzer open:self.audioTrack];
    float expectedBpm = 120.0f;
    
    // Create the callback block
    void(^callback)(float bpm);
    callback = ^void(float bpm) {
        
        // Asynchronously fulfill the test expectation
        [self.testThatBpmCanBeFetchedDefaultConstructorExpectation fulfill];
        XCTAssertEqual(bpm, expectedBpm);
        
    };
    
    // Set the expectation timer
    self.testThatBpmCanBeFetchedDefaultConstructorExpectation = [self expectationWithDescription:@"BPM should have been set"];
    
    // Asynchronously process the BPM
    [self.analyzer asyncProcessBpm:callback];
    
    // If we timeout, something went wrong
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testThatBpmCanBeFetchedDefaultConstructorDifferentThread {
    AudioAnalyzer *analyzer = [[AudioAnalyzer alloc] init];
    float expectedBpm = 120.0f;
    
    // Create the separate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [analyzer open:self.audioTrack];
        
        void(^callback)(float bpm);
        callback = ^void(float bpm) {
        
            // Asynchronously fulfill the test expectation
            [self.testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation fulfill];
            XCTAssertEqual(bpm, expectedBpm);
        
        };
        
        // Asynchronously process the BPM
        [self.analyzer asyncProcessBpm:callback];
        
    });
    
    // Set the expectation timer
    self.testThatBpmCanBeFetchedDefaultConstructorDifferentThreadExpectation = [self expectationWithDescription:@"BPM should have been set"];

    
    // If we timeout, something went wrong
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


@end
