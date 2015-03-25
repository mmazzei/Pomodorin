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
        // TODO - Load record from disk?
        _theRecord = [[Record alloc] init];
        
        NSLog(@"Loading sample data...");
        NSDate* twoDaysAgo = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24*2)];
        Pomodoro* sample1 = [[Pomodoro alloc] init];
        sample1.internalInterruptions = 3;
        sample1.externalInterruptions = 1;
        Pomodoro* sample2 = [[Pomodoro alloc] init];
        sample2.internalInterruptions = 2;
        sample2.externalInterruptions = 2;
        
        NSDate* oneDaysAgo = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24*1)];
        Pomodoro* sample3 = [[Pomodoro alloc] init];
        sample3.internalInterruptions = 15;
        Pomodoro* sample4 = [[Pomodoro alloc] init];
        sample4.externalInterruptions = 14;

    
        [_theRecord add:sample1 at:twoDaysAgo];
        [_theRecord add:sample2 at:twoDaysAgo];
        [_theRecord add:sample3 at:oneDaysAgo];
        [_theRecord add:sample4 at:oneDaysAgo];
        NSLog(@"Sample data loaded.");
    }
    
    return self;
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
