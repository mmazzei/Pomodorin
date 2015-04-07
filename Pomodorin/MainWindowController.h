//
//  MainWindowController.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/6/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TodayStatus;

@interface MainWindowController : NSWindowController
@property (weak) IBOutlet NSView *mainView;
@property(strong) TodayStatus *model;
@end
