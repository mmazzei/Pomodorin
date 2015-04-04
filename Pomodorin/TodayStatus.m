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
#import "ShortBreak.h"
#import "LongBreak.h"
#import "Record.h"
#import "Config.h"
#import "Session.h"

@interface TodayStatus ()
@property(strong, readonly) Record *theRecord;
@property(strong, readonly) Session *session;
@end

@implementation TodayStatus

- (id)init {
  self = [super init];

  if (self) {
    _theRecord = [[Record alloc] init];
    _config = [[Config alloc] init];
    _session = [[Session alloc] init];
    _session.config = _config;
    _automaticMode = FALSE;
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  NSLog(@"Initializing TodayStatus with decoder");
  self = [super init];
  if (self) {
    _theRecord = [decoder decodeObjectForKey:@"record"];
    if (!_theRecord) _theRecord = [[Record alloc] init];

    _session = [decoder decodeObjectForKey:@"session"];
    if (!_session) _session = [[Session alloc] init];
    _session.config = _config;

    _currentTask = [decoder decodeObjectForKey:@"currentTask"];
    _automaticMode = [decoder decodeBoolForKey:@"automaticMode"];
  }

  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  NSLog(@"Encoding TodayStatus with coder");
  [coder encodeObject:self.record forKey:@"record"];
  [coder encodeObject:self.session forKey:@"session"];
  [coder encodeObject:self.currentTask forKey:@"currentTask"];
  [coder encodeBool:self.automaticMode forKey:@"automaticMode"];
}

- (Record *)record {
  [self recordCurrentTaskIfFinished];
  return self.theRecord;
}

- (TimeBox *)recommendedTimebox {
  [self recordCurrentTaskIfFinished];
  return [self.session recommendedTimebox];
}

- (void)discardCurrentTimebox {
  self.currentTask = nil;
}

- (void)startAPomodoro {
  [self recordCurrentTaskIfFinished];
  self.currentTask = [[Pomodoro alloc] initWithConfig:self.config];
}

- (void)startAShortBreak {
  [self recordCurrentTaskIfFinished];
  self.currentTask = [[ShortBreak alloc] initWithConfig:self.config];
}

- (void)startALongBreak {
  [self recordCurrentTaskIfFinished];
  self.currentTask = [[LongBreak alloc] initWithConfig:self.config];
}

- (void)recordCurrentTaskIfFinished {
  if ([self.currentTask isExpired]) {
    [self.session add:self.currentTask];

    // Only record finished pomodoros
    if (self.currentTask.type == POMODORO) {
      [self.theRecord add:(Pomodoro *)self.currentTask at:[NSDate date]];
    }
    self.currentTask = nil;
  }
}
@end
