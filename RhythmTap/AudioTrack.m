//
//  AudioTrack.m
//  RhythmTap
//
//  Created by Brian Yip on 2016-03-06.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioTrack.h"

@implementation AudioTrack : NSObject 

- (id)init {
    self = [super init];
    self->_file = @"";
    self->_audioFormat = @"";
    return self;
}

- (id)init: (NSString*)file audioFormat:(NSString*)format {
    self = [super init];
    self->_file = file;
    self->_audioFormat = format;
    return self;
}

@end