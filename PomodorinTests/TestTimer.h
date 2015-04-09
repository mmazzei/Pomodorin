//
//  TestTimer.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

// This is a timer delegate that will return the same date
// as "now" until the "advanceXXXX" methods are called.
@interface TestTimer : NSObject<TimerDelegate>
- (NSDate*)now;

// Updates the value returned by 'now'.
- (void)advance:(NSTimeInterval)interval;
@end
