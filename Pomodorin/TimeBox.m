//
//  CurrentTask.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TimeBox.h"

@implementation TimeBox

- (id) initWithType:(int) taskType expiringOn:(NSDate*)date {
    self = [super init];
    
    if (self) {
        _type = taskType;
        _expiresOn = date;
    }
    
    return self;
}

- (BOOL) isExpired {
    return ([self.expiresOn compare:[NSDate date]] != NSOrderedDescending);
}

@end
