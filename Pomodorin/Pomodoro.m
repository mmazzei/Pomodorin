//
//  Pomodoro.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Pomodoro.h"
#import "GlobalDeclarations.h"
#import "Config.h"

@implementation Pomodoro

- (id)initWithCoder:(NSCoder *)decoder {
  NSLog(@"Initializing Pomodoro with decoder");
  self = [super initWithCoder:decoder];
  if (self) {
    _internalInterruptions = [decoder decodeIntForKey:@"internalInterruptions"];
    _externalInterruptions = [decoder decodeIntForKey:@"externalInterruptions"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  NSLog(@"Encoding Pomodoro with coder");
  [super encodeWithCoder:coder];
  [coder encodeInt:self.internalInterruptions forKey:@"internalInterruptions"];
  [coder encodeInt:self.externalInterruptions forKey:@"externalInterruptions"];
}

- (id)initWithConfig:(Config *)config {
  // Expires on X minutes from now
  NSDate *expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:config.pomodoroLength * SECONDS_IN_A_MINUTE];

  self = [super initExpiringOn:expiresOn];

  return self;
}

- (TaskType) type {
  return POMODORO;
}
@end
