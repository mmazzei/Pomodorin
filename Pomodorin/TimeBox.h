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
@property(readonly) NSDate *expiresOn;

- (id)initExpiringOn:(NSDate *)date;
- (BOOL)isExpired;
- (TaskType) type;
@end
