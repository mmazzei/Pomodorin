//
//  PreferencesWindowController.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TodayStatus;

@interface PreferencesWindowController : NSWindowController
@property(strong) TodayStatus *model;

@property(weak) IBOutlet NSSlider *pomodoroSlider;
@property(weak) IBOutlet NSSlider *shortBreakSlider;
@property(weak) IBOutlet NSSlider *longBreakSlider;
@property(weak) IBOutlet NSTextField *pomodoroLabel;
@property(weak) IBOutlet NSTextField *shortBreakLabel;
@property(weak) IBOutlet NSTextField *longBreakLabel;

- (IBAction)updatePomodoroLength:(id)sender;
- (IBAction)updateShortBreakLength:(id)sender;
- (IBAction)updateLongBreakLength:(id)sender;
@end
