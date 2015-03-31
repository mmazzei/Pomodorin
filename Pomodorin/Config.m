//
//  Config.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Config.h"
#import "GlobalDeclarations.h"
#import "TimeBox.h"

@implementation Config

-(NSString*) imageNameFor:(int)taskType {
    switch (taskType) {
        case POMODORO: return @"tomato";
        case SHORT_BREAK: return @"hourglass";
        case LONG_BREAK: return @"dark_hourglass";
    }
    return @"";
}

@end
