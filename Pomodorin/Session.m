//
//  Session.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/1/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Session.h"
#import "TimeBox.h"
#import "Timer.h"
#import "Pomodoro.h"
#import "ShortBreak.h"
#import "LongBreak.h"

// Number of complete pomodoris for each long break
static const NSUInteger POMODORIS_EACH_LONG_BREAK = 4;

// Number of timeboxes needed for the recommend heuristic
static const NSUInteger MAX_TIMEBOXES_TO_REMEMBER = POMODORIS_EACH_LONG_BREAK*2 - 1;

// If the last remembered timebox is older than this, too much idle time
// has gone until now to be considered as a part of the same pomodoro session.
// For example:
//   - the last timebox is a pomodoro
//   - the user goes away for 1h
//   - the user comes back, the recommended action is a break
//  That makes no sense.
// The correct way to do that is to forgot the actions after certain
// period of time. This const configures that.
// IN MINUTES
static const NSUInteger MAX_TIME_TO_REMEMBER = 60;

@interface Session ()
@property(strong) NSMutableArray *lastFinishedTimeboxes;
@end

@implementation Session
- (id)init {
  self = [super init];

  if (self) {
    _lastFinishedTimeboxes = [NSMutableArray arrayWithCapacity:MAX_TIMEBOXES_TO_REMEMBER];
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  NSLog(@"Initializing Session with decoder");
  self = [super init];
  if (self) {
    _lastFinishedTimeboxes = [decoder decodeObjectForKey:@"lastFinishedTimeboxes"];
    if (!_lastFinishedTimeboxes) {
      _lastFinishedTimeboxes = [NSMutableArray arrayWithCapacity:MAX_TIMEBOXES_TO_REMEMBER];
    }
  }

  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  NSLog(@"Encoding Session with coder");
  [coder encodeObject:self.lastFinishedTimeboxes forKey:@"lastFinishedTimeboxes"];
}

- (NSUInteger)ageInMinutes {
  NSUInteger age = 0;

  if ([self.lastFinishedTimeboxes count] > 0) {
    TimeBox *lastTimebox = [self.lastFinishedTimeboxes lastObject];
    NSDate *now = [Timer.sharedInstance now];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:NSCalendarUnitMinute
                                               fromDate:lastTimebox.expiresOn
                                                 toDate:now
                                                options:0];
    age = [difference minute];
  }

  return age;
}

- (void)add:(TimeBox *)timeBox {
  // The lastFinishedTimeboxes is like a time window, so, when adding
  // one element to the end, remove the first one.
  if (self.lastFinishedTimeboxes.count == MAX_TIMEBOXES_TO_REMEMBER) {
    [self.lastFinishedTimeboxes removeObjectAtIndex:0];
  }
  [self.lastFinishedTimeboxes addObject:timeBox];
}

// The heuristic is basic:
//   - After a pomodoro allways recommend a break (short or long)
//   - After a break (short or long) allways recommend a pomodoro
//   - Recommend short breaks except in the case of the succession:
//        (Pomodoro-ShortBreak)x3-Pomodoro
//     In that case, recommend a long break
- (TimeBox *)recommendedTimebox {
  [self forgotTimeboxesIfTooOld];
  TimeBox *recommendation = nil;
  TimeBox *lastTimebox = self.lastFinishedTimeboxes.lastObject;

  if (!lastTimebox || (lastTimebox.type == SHORT_BREAK) || (lastTimebox.type == LONG_BREAK)) {
    NSLog(@"No timeboxes executed during this session, or last timebox is a break => Recommend a pomodoro");
    recommendation = [[Pomodoro alloc] initWithConfig:self.config];
  }
  // Recommend long-break timebox if P-S-P-S-P-S-P
  // Do not need to check if the lastTimebox is a pomodoro because
  // in the previous if we checked for the other two posibilites, so
  // we know that if are here, IS a pomodoro.
  else if ((self.lastFinishedTimeboxes.count == MAX_TIMEBOXES_TO_REMEMBER) &&
           [self arePomodoroAndShortBreakIn:self.lastFinishedTimeboxes at:0 repetitions:POMODORIS_EACH_LONG_BREAK-1]) {
    NSLog(@"Three series of [Pomodoro,ShortBreak] and a Pomodoro => Recommend a long break");
    recommendation = [[LongBreak alloc] initWithConfig:self.config];
  } else {
    // Short-break timebox in other case
    NSLog(@"Last timebox is a pomodoro, without any previous valid pattern => Recommend a short break");
    recommendation = [[ShortBreak alloc] initWithConfig:self.config];
  }
  return recommendation;
}

// Returns true only if there are the number of repetitions of
// [Pomodoro,ShortBreak] in the array, counting from the given
// index.
- (BOOL)arePomodoroAndShortBreakIn:(NSArray *)array
                             at:(NSUInteger)index
                    repetitions:(NSUInteger)count {
  if (count == 0) return TRUE;
  TimeBox *firstElem = array[index];
  TimeBox *secondElem = array[index + 1];

  return (firstElem.type == POMODORO) && (secondElem.type == SHORT_BREAK) && [self arePomodoroAndShortBreakIn:array
                                    at:index + 2
                           repetitions:count - 1];
}

- (void)forgotTimeboxesIfTooOld {
  NSUInteger age = [self ageInMinutes];
  if (age > MAX_TIME_TO_REMEMBER) {
    NSLog(@"Forgetting the session because the age is %lu minutes.", age);
    [self.lastFinishedTimeboxes removeAllObjects];
  }
}

@end
