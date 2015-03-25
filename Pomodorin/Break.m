//
//  Break.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Break.h"
#import "Configs.h"

@implementation Break

-(id) initWithType:(TaskType)type {
    int breakMinutes = SHORT_BREAK_DURATION;
    if (type == LONG_BREAK) {
        breakMinutes = LONG_BREAK_DURATION;
    }

    NSDate* expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(breakMinutes)];
    
    self = [super initWithType:type expiringOn:expiresOn];
    
    return self;
}

@end
