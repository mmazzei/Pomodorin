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
#import "Session.h"


@interface TodayStatus ()
@property (strong, readonly) Record* theRecord;
@property (strong, readonly) Session* session;
@end

@implementation TodayStatus

-(id) init {
    self = [super init];
    
    if (self) {
        _theRecord = [[Record alloc] init];
        _config = [[Config alloc] init];
        _session = [[Session alloc] init];
        _session.config = _config;
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initializing TodayStatus with decoder");
    self = [super init];
    if (self) {
        _theRecord = [decoder decodeObjectForKey:@"record"];
        if (! _theRecord) _theRecord = [[Record alloc] init];
        
        _session = [decoder decodeObjectForKey:@"session"];
        if (!_session) _session = [[Session alloc] init];
        _session.config = _config;

        _currentTask = [decoder decodeObjectForKey:@"currentTask"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding TodayStatus with coder");
    [coder encodeObject:self.record forKey:@"record"];
    [coder encodeObject:self.session forKey:@"session"];
    [coder encodeObject:self.currentTask forKey:@"currentTask"];
}

-(Record*) record {
    [self recordCurrentTaskIfFinished];
    return self.theRecord;
}
            
-(TimeBox*) recommendedTimebox {
    return [self.session recommendedTimebox];
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
        [self.session add:self.currentTask];
        
        // Only record finished pomodoros
        if (self.currentTask.type == POMODORO) {
            [self.theRecord add:(Pomodoro*)self.currentTask at:[NSDate date]];
        }
        self.currentTask = nil;
    }
}
@end
