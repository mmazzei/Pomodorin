//
//  TodayStatus.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TodayStatus.h"
#import "GlobalDeclarations.h"
#import "TimeBox.h"
#import "Pomodoro.h"
#import "Break.h"
#import "Record.h"
#import "Config.h"

static const NSUInteger MAX_TIMEBOXES_TO_REMEMBER_FOR_AUTO_MODE = 7;

@interface TodayStatus ()
@property (strong, readonly) Record* theRecord;
@property (strong) NSMutableArray* lastFinishedTimeboxes;
@end

@implementation TodayStatus

-(id) init {
    self = [super init];
    
    if (self) {
        _theRecord = [[Record alloc] init];
        _config = [[Config alloc] init];
        _lastFinishedTimeboxes = [NSMutableArray arrayWithCapacity:MAX_TIMEBOXES_TO_REMEMBER_FOR_AUTO_MODE];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initializing TodayStatus with decoder");
    self = [super init];
    if (self) {
        _theRecord = [decoder decodeObjectForKey:@"record"];
        if (! _theRecord) _theRecord = [[Record alloc] init];
        
        _lastFinishedTimeboxes = [decoder decodeObjectForKey:@"lastFinishedTimeboxes"];
        if (!_lastFinishedTimeboxes) {
            _lastFinishedTimeboxes = [NSMutableArray arrayWithCapacity:MAX_TIMEBOXES_TO_REMEMBER_FOR_AUTO_MODE];
        }
        
        _currentTask = [decoder decodeObjectForKey:@"currentTask"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding TodayStatus with coder");
    [coder encodeObject:self.record forKey:@"record"];
    [coder encodeObject:self.lastFinishedTimeboxes forKey:@"lastFinishedTimeboxes"];
    [coder encodeObject:self.currentTask forKey:@"currentTask"];
}

-(Record*) record {
    [self recordCurrentTaskIfFinished];
    return self.theRecord;
}

// The heuristic is basic:
//   - After a pomodoro allways recommend a break (short or long)
//   - After a break (short or long) allways recommend a pomodoro
//   - Recommend short breaks except in the case of the succession:
//        (Pomodoro-ShortBreak)x3-Pomodoro
//     In that case, recommend a long break
-(TimeBox*) recommendedTimebox {
    TimeBox * recommendation = nil;
    TimeBox* lastTimebox = self.lastFinishedTimeboxes.lastObject;

    if ((lastTimebox.type == SHORT_BREAK) || (lastTimebox.type == LONG_BREAK)) {
        NSLog(@"Last timebox is a break => Recommend a pomodoro");
        recommendation = [[Pomodoro alloc] initWithConfig:self.config];
    }
    else  if (self.lastFinishedTimeboxes.count == MAX_TIMEBOXES_TO_REMEMBER_FOR_AUTO_MODE) {
        // Recommend long-break timebox if P-S-P-S-P-S-P
        // Do not need to check if the lastTimebox is a pomodoro because
        // in the previous if we checked for the other two posibilites, so
        // we know that if are here, IS a pomodoro.
        if ([self pomodoroAndShortBreakIn:self.lastFinishedTimeboxes at:0 repetitions:3]) {
            NSLog(@"Three series of [Pomodoro,ShortBreak] and a Pomodoro => Recommend a long break");
            recommendation = [[Break alloc] initWithType:LONG_BREAK andConfig:self.config];
        }
        // Short-break timebox in other case
        else {
            NSLog(@"Last timebox is a pomodoro, without any previous valid pattern => Recommend a short break");
            recommendation =  [[Break alloc] initWithType:SHORT_BREAK andConfig:self.config];
        }
    }
    return recommendation;
}

// Returns true only if there are the number of repetitions of
// [Pomodoro,ShortBreak] in the array, counting from the given
// index.
-(BOOL) pomodoroAndShortBreakIn:(NSArray*)array at:(NSUInteger)index repetitions:(NSUInteger)count{
    if (count == 0) return TRUE;
    TimeBox* firstElem = array[index];
    TimeBox* secondElem = array[index+1];
    
    return (firstElem.type == POMODORO) && (secondElem.type == SHORT_BREAK) && [self pomodoroAndShortBreakIn:array at:index+2 repetitions:count-1];
}
        
-(void) discardCurrentTimebox {
    self.currentTask = nil;
}

-(void) startAPomodoro {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Pomodoro alloc] initWithConfig:self.config];
}

-(void) startAShortBreak {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Break alloc] initWithType:SHORT_BREAK andConfig:self.config];
}

-(void) startALongBreak {
    [self recordCurrentTaskIfFinished];
    self.currentTask = [[Break alloc] initWithType:LONG_BREAK andConfig:self.config];
}

-(void) recordCurrentTaskIfFinished {
    if ([self.currentTask isExpired]) {
        // The lastFinishedTimeboxes is like a time window, so, when adding
        // one element to the end, remove the first one.
        if (self.lastFinishedTimeboxes.count == MAX_TIMEBOXES_TO_REMEMBER_FOR_AUTO_MODE) {
            [self.lastFinishedTimeboxes removeObjectAtIndex:0];
        }
        [self.lastFinishedTimeboxes addObject:self.currentTask];
        
        // Only record finished pomodoros
        if (self.currentTask.type == POMODORO) {
            [self.theRecord add:(Pomodoro*)self.currentTask at:[NSDate date]];
        }
        self.currentTask = nil;
    }
}
@end
