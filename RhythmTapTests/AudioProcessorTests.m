//
//  AudioProcessorTests.m
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-05.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RhythmTap-Bridging-Header.h"

@interface AudioProcessorTests : XCTestCase

@property (nonatomic) AudioProcessor *audioProcessor;

@end



@implementation AudioProcessorTests

- (void)setUp {
    [super setUp];
    self.audioProcessor = [[AudioProcessor alloc] init];
}

- (void)tearDown {
    [super tearDown];
}


@end
