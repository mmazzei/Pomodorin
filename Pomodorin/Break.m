//
//  Break.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Break.h"
#import "Config.h"

@implementation Break

- (id) initWithType:(TaskType) type andConfig:(Config*)config {
    NSInteger breakMinutes = config.shortBreakLength;
    if (type == LONG_BREAK) {
        breakMinutes = config.longBreakLength;
    }
    
    NSDate* expiresOn = [[NSDate alloc] initWithTimeIntervalSinceNow:(breakMinutes * 60)];
    
    self = [super initWithType:type expiringOn:expiresOn];
    
    return self;
}

@end
