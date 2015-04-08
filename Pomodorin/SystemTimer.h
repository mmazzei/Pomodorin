//
//  SystemTimer.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timer.h"

// This delegate uses the system clock to obtain the current time
@interface SystemTimer : NSObject<TimerDelegate>
- (NSDate*)now;
@end
