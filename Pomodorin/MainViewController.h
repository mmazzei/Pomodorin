//
//  MainViewController.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TodayStatus;

@interface MainViewController : NSViewController
@property(strong) TodayStatus *model;
@end
