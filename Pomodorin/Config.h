//
//  Config.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
// Lengths in minutes
@property (assign) NSInteger pomodoroLength;
@property (assign) NSInteger shortBreakLength;
@property (assign) NSInteger longBreakLength;
@end
