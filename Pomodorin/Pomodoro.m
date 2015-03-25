//
//  Pomodoro.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Pomodoro.h"
#import "Configs.h"

@implementation Pomodoro

-(id) init {
    // Expires on X minutes from now
    NSDate* expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(POMODORO_DURATION)];

    self = [super initWithType:POMODORO expiringOn:expiresOn];
   
    return self;
}
@end
