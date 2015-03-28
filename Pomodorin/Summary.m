//
//  Summary.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/25/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Summary.h"
#import "GlobalDeclarations.h"
#import "Pomodoro.h"

@implementation Summary

-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initializing Summary with decoder");
    self = [super init];
    if (self) {
        _pomodoros = [decoder decodeIntegerForKey:@"pomodoros"];
        _internalInterruptions = [decoder decodeIntegerForKey:@"internalInterruptions"];
        _externalInterruptions = [decoder decodeIntegerForKey:@"externalInterruptions"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding Summary with coder");
    [coder encodeInteger:self.pomodoros forKey:@"pomodoros"];
    [coder encodeInteger:self.internalInterruptions forKey:@"internalInterruptions"];
    [coder encodeInteger:self.externalInterruptions forKey:@"externalInterruptions"];
}

-(void) add:(Pomodoro*) pomodoro {
    self.pomodoros ++;
    self.internalInterruptions += pomodoro.internalInterruptions;
    self.externalInterruptions += pomodoro.externalInterruptions;
}
@end
