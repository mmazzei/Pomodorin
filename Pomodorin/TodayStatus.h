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
@class Config;

// This class behaves mainly as an app context object
// Should be renamed to reflect that and do not confound with "today only" status
@interface TodayStatus : NSObject <NSCoding>
@property (strong) TimeBox* currentTask;
@property (strong) Config* config;

-(Record*) record;
-(TimeBox*) recommendedTimebox;

-(void) discardCurrentTimebox;

-(void) startAPomodoro;
-(void) startAShortBreak;
-(void) startALongBreak;
@end
