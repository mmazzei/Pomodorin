//
//  ShortBreak.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "ShortBreak.h"
#import "GlobalDeclarations.h"
#import "Config.h"

@implementation ShortBreak

- (id)initWithConfig:(Config *)config {
  NSInteger breakMinutes = config.shortBreakLength;
  NSDate *expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(breakMinutes * SECONDS_IN_A_MINUTE)];

  self = [super initWithType:SHORT_BREAK expiringOn:expiresOn];

  return self;
}

@end
