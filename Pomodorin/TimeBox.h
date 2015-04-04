//
//  CurrentTask.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { POMODORO, SHORT_BREAK, LONG_BREAK } TaskType;

@interface TimeBox : NSObject <NSCoding>
@property(readonly) int type;
@property(readonly) NSDate *expiresOn;

- (id)initWithType:(int)taskType expiringOn:(NSDate *)date;
- (BOOL)isExpired;
@end
