//
//  Config.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Config.h"

@implementation Config
-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initializing Config with decoder");

    if (self) {
        _pomodoroLength = [decoder decodeIntegerForKey:@"pomodoroLength"];
        _shortBreakLength = [decoder decodeIntegerForKey:@"shortBreakLength"];
        _longBreakLength = [decoder decodeIntegerForKey:@"longBreakLength"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding Config with coder");

    [coder encodeInteger:self.pomodoroLength forKey:@"pomodoroLength"];
    [coder encodeInteger:self.shortBreakLength forKey:@"shortBreakLength"];
    [coder encodeInteger:self.longBreakLength forKey:@"longBreakLength"];
}

@end
