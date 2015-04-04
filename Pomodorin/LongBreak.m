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

@implementation LongBreak

- (id)initWithConfig:(Config *)config {
  NSInteger breakMinutes = config.shortBreakLength;
  NSDate *expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(breakMinutes * SECONDS_IN_A_MINUTE)];
  
  self = [super initWithType:LONG_BREAK expiringOn:expiresOn];
  
  return self;
}

@end
