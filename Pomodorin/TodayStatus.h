//
//  TodayStatus.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeBox;
@class Record;

// This class behaves mainly as an app context object
// Should be renamed to reflect that and do not confound with "today only" status
@interface TodayStatus : NSObject
@property (strong) TimeBox* currentTask;

-(Record*) record;
-(void) discardCurrentTimebox;

-(void) startAPomodoro;
-(void) startAShortBreak;
-(void) startALongBreak;
@end
