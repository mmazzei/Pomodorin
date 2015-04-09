//
//  TestTimer.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TestTimer.h"

@interface TestTimer()
@property (strong) NSDate* currentDate;
@end

@implementation TestTimer

- (id) init {
  self = [super init];
  if (self) {
    _currentDate = [[NSDate alloc] init];
  }
  return self;
}

- (NSDate*)now {
  return self.currentDate;
}

- (void)advance:(NSTimeInterval)interval {
  NSDate* newDate = [self.currentDate dateByAddingTimeInterval:interval];
  NSLog(@"TestTimer advancing: %f seconds, from %@ to %@.", interval, self.currentDate, newDate);
  self.currentDate = newDate;
}

@end
