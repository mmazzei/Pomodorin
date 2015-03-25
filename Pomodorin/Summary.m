//
//  Summary.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/25/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Summary.h"
#import "Pomodoro.h"

@implementation Summary

-(void) add:(Pomodoro*) pomodoro {
    self.pomodoros ++;
    self.internalInterruptions += pomodoro.internalInterruptions;
    self.externalInterruptions += pomodoro.externalInterruptions;
}
@end
