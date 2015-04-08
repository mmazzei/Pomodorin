//
//  CurrentTask.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TimeBox.h"
#import "Timer.h"
#import "GlobalDeclarations.h"

@implementation TimeBox

- (id)initExpiringOn:(NSDate *)date {
  self = [super init];

  if (self) {
    _expiresOn = date;
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  NSLog(@"Initializing TimeBox with decoder");
  self = [super init];
  if (self) {
    _expiresOn = [decoder decodeObjectForKey:@"expiresOn"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  NSLog(@"Encoding TimeBox with coder");
  [coder encodeObject:self.expiresOn forKey:@"expiresOn"];
}

- (BOOL)isExpired {
  return ([self.expiresOn compare:[Timer.sharedInstance now]] != NSOrderedDescending);
}

- (TaskType)type {
  @throw [NSException exceptionWithName:@"Invalid method call" reason:@"You tried to use directly the abstract TimeBox class" userInfo:@{}];
}
@end
