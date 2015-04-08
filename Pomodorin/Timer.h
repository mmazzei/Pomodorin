//
//  Timer.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimerDelegate <NSObject>
- (NSDate*)now;
@end

// This classs provides an abstraction over the system clock
// in order to allow implement unit tests for functionality
// depending on the advance of the time.
//
// Is not a so good design to use a configurable singleton
// (with the delegate), but is a first approach to allow
// to have what I need.
//
// A better way to do so could be with a Dependency Injection
// framework.
@interface Timer : NSObject
@property (strong) id <TimerDelegate> delegate;

+ (Timer *)sharedInstance;

// Return the current date.
// If no delegate is configured, will return nil.
- (NSDate*)now;
@end
