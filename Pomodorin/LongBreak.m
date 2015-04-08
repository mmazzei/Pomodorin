//
//  LongBreak.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/4/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "LongBreak.h"
#import "GlobalDeclarations.h"
#import "Config.h"
#import "Timer.h"

@implementation LongBreak

- (id)initWithConfig:(Config *)config {
  NSInteger breakMinutes = config.longBreakLength;
  NSDate *expiresOn = [[Timer.sharedInstance now] dateByAddingTimeInterval:(breakMinutes * SECONDS_IN_A_MINUTE)];
  
  self = [super initExpiringOn:expiresOn];
  
  return self;
}

- (TaskType) type {
  return LONG_BREAK;
}
@end
