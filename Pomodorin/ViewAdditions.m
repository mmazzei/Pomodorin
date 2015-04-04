//
//  ViewAdditions.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/4/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "ViewAdditions.h"

#import "Pomodoro.h"
#import "ShortBreak.h"
#import "LongBreak.h"

@implementation Pomodoro (ViewAdditions)
+ (NSString *)imageName {
  return @"tomato";
}
@end

@implementation ShortBreak (ViewAdditions)
+ (NSString *)imageName {
  return @"hourglass";
}
@end

@implementation LongBreak (ViewAdditions)
+ (NSString *)imageName {
  return @"dark_hourglass";
}
@end
