//
//  Break.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeBox.h"
@class Config;

@interface Break : TimeBox
- (id)initWithType:(TaskType)type andConfig:(Config *)config;
@end
