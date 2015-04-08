//
//  Timer.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Timer.h"

@implementation Timer
static Timer* instance = nil;

// This method is automatically called from the runtime when the class
// is first used.
+ (void)initialize {
  NSLog(@"Initializing Timer class");
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    instance = [[Timer alloc] init];
  });
}

+ (Timer *)sharedInstance {
  return instance;
}

- (NSDate*)now {
  return [self.delegate now];
}

@end
