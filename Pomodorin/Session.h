//
//  Session.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/1/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimeBox;
@class Config;

@interface Session : NSObject <NSCoding>
@property(strong) Config *config;

// Is equivalent to the age, in minutes, of the last added timebox
- (NSUInteger)ageInMinutes;

// Register a timebox completion in the session
- (void)add:(TimeBox *)timeBox;

// Taking into account the last various timebox completions,
// executes an heuristic to recommend the next one to do.
- (TimeBox *)recommendedTimebox;
@end
