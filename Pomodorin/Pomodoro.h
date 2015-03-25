//
//  Pomodoro.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>

// This didn't worked, producing "Class 'Pomodoro'defined without specifying a base class" error message.
// @class CurrentTask;
// So, I replaced by this import:
#import "TimeBox.h"

@interface Pomodoro : TimeBox
@property (assign) int internalInterruptions;
@property (assign) int externalInterruptions;

@end
