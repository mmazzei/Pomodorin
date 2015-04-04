//
//  Record.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/25/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Summary;
@class Pomodoro;

// Contains the summary day by day
@interface Record : NSObject <NSCoding>
@property(strong, readonly) NSMutableDictionary *record;

- (void)add:(Pomodoro *)pomodoro at:(NSDate *)day;
- (Summary *)summaryAt:(NSDate *)day;

- (NSString *)print;
@end
