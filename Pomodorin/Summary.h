//
//  Summary.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/25/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Pomodoro;

// A summary containing the info about how many
// pomodoros were done, and their interruptions.
@interface Summary : NSObject <NSCoding>

@property(assign) NSUInteger pomodoros;
@property(assign) NSUInteger internalInterruptions;
@property(assign) NSUInteger externalInterruptions;

// Adds the pomodoro data to the summary
- (void)add:(Pomodoro *)pomodoro;
@end
