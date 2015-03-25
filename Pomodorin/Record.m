
//
//  Record.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/25/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "Record.h"
#import "Summary.h"

@interface Record ()
+(id) keyFor:(NSDate *)date;
@end

@implementation Record

-(id) init {
    self = [super init];
    if (self) {
        _record = [NSMutableDictionary dictionary];
    }
    return self;
}

// Adds the pomodoro to the summarized data for the given day.
// If there are no summarized data yet, initializes it.
-(void) add:(Pomodoro*)pomodoro at:(NSDate*)day {
    Summary* summaryForDay = [self summaryAt:day];
    
    if (!summaryForDay) {
        summaryForDay = [[Summary alloc] init];
        self.record[[Record keyFor:day]] = summaryForDay;
    }

    [summaryForDay add:pomodoro];
}

-(Summary*) summaryAt:(NSDate*)day {
    return  self.record[[Record keyFor:day]];
}

// Returns the key where the summary for a given date should
// be stored in the record dictionary
+(id) keyFor:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    // Use always the same locale, independently of the user choice,
    // in order to produce the same result in their different devices
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    return [dateFormatter stringFromDate:date];
}

-(void) print {
    NSLog(@"Record details:");
    NSArray* sortedKeys = [[self.record allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for(NSString* key in sortedKeys) {
        Summary* summary = self.record[key];
        NSLog(@"\t%@ -> (%lu, %lu, %lu)", key, summary.pomodoros, summary.internalInterruptions, summary.externalInterruptions);
    }
}

@end
