//
//  TodayStatus.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TodayStatus.h"
#import "TimeBox.h"
#import "Pomodoro.h"
#import "Break.h"
#import "Record.h"

@interface TodayStatus ()
@property (strong, readonly) Record* theRecord;
@end

@implementation TodayStatus

-(id) init {
    self = [super init];
    
    if (self) {
        _theRecord = [[Record alloc] init];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initing TodayStatus with decoder");
    self = [super init];
    if (self) {
        _theRecord = [decoder decodeObjectForKey:@"record"];
        _currentTask = [decoder decodeObjectForKey:@"currentTask"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding TodayStatus with coder");
    [coder encodeObject:self.record forKey:@"record"];
    [coder encodeObject:self.currentTask forKey:@"currentTask"];
}

-(Record*) record {
    [self recordCurrentTaskIfFinished];
    return self.theRecord;
}

-(void) discardCurrentTimebox {
    self.currentTask = nil;
}

-(void) startAPomodoro {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Pomodoro alloc] init];
}

-(void) startAShortBreak {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Break alloc] initWithType:SHORT_BREAK];
}

-(void) startALongBreak {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Break alloc] initWithType:LONG_BREAK];
}

-(void) recordCurrentTaskIfFinished {
    // Only record finished pomodoros
    if ((self.currentTask.type == POMODORO) && [self.currentTask isExpired]) {
        [self.theRecord add:(Pomodoro*)self.currentTask at:[NSDate date]];
        self.currentTask = nil;
    }
}
@end
