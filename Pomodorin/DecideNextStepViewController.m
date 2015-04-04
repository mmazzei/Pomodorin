//
//  DecideNextStepViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "DecideNextStepViewController.h"
#import "GlobalDeclarations.h"
#import "AppDelegate.h"

#import "TodayStatus.h"
#import "TimeBox.h"
#import "Record.h"
#import "Config.h"

@interface DecideNextStepViewController ()
@property(weak) IBOutlet NSButton *recommendedActionButton;
@property(weak) IBOutlet NSButton *startOption1Button;
@property(weak) IBOutlet NSButton *startOption2Button;

@property(copy) void (^recommendedActionBlock)(id);
@property(copy) void (^startOption1Block)(id);
@property(copy) void (^startOption2Block)(id);
@end

@implementation DecideNextStepViewController

- (void)viewDidAppear {
  if (self.model.automaticMode) {
    switch (self.model.recommendedTimebox.type) {
    case POMODORO: [self.model startAPomodoro]; break;
    case SHORT_BREAK: [self.model startAShortBreak]; break;
    case LONG_BREAK: [self.model startALongBreak]; break;
    }

    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
  } else {
    [self.view setHidden:FALSE];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // To avoid a strong reference cycle
  DecideNextStepViewController *__weak tmpSelf = self;

  // This is needed in order to draw a pixelated image
  [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
  switch ([self.model recommendedTimebox].type) {
  case SHORT_BREAK: {
    // If recommended timebox is Short Break then
    //   - recommendedActionButton => Starts a Short Break
    //   - startOption1Button => Starts a Pomodoro
    //   - startOption2Button => Start a Long Break
    self.recommendedActionButton.image = [NSImage imageNamed:[self.model.config imageNameFor:SHORT_BREAK]];
    self.recommendedActionButton.toolTip = @"Start a Short Break";
    self.recommendedActionBlock = ^(id sender) {[tmpSelf startShortBreak:sender];};

    self.startOption1Button.image = [NSImage imageNamed:[self.model.config imageNameFor:POMODORO]];
    self.startOption1Button.toolTip = @"Start a Pomodoro";
    self.startOption1Block = ^(id sender) {[tmpSelf startPomodoro:sender];};

    self.startOption2Button.image = [NSImage imageNamed:[self.model.config imageNameFor:LONG_BREAK]];
    self.startOption2Button.toolTip = @"Start a Long Break";
    self.startOption2Block = ^(id sender) {[tmpSelf startLongBreak:sender];};
  } break;
  case LONG_BREAK: {
    // If recommended timebox is Short Break then
    //   - recommendedActionButton => Starts a Long Break
    //   - startOption1Button => Starts a Short Break
    //   - startOption2Button => Start a Pomodoro
    self.recommendedActionButton.image = [NSImage imageNamed:[self.model.config imageNameFor:LONG_BREAK]];
    self.recommendedActionButton.toolTip = @"Start a Long Break";
    self.recommendedActionBlock = ^(id sender) {[tmpSelf startLongBreak:sender];};

    self.startOption1Button.image = [NSImage imageNamed:[self.model.config imageNameFor:SHORT_BREAK]];
    self.startOption1Button.toolTip = @"Start a Short Break";
    self.startOption1Block = ^(id sender) {[tmpSelf startShortBreak:sender];};

    self.startOption2Button.image = [NSImage imageNamed:[self.model.config imageNameFor:POMODORO]];
    self.startOption2Button.toolTip = @"Start a Pomodoro";
    self.startOption2Block = ^(id sender) {[tmpSelf startPomodoro:sender];};
  } break;
  default: {
    // If recommended timebox is Pomodoro or unknown then
    //   - recommendedActionButton => Starts a Pomodoro
    //   - startOption1Button => Starts a Short Break
    //   - startOption2Button => Start a Long Break
    self.recommendedActionButton.image = [NSImage imageNamed:[self.model.config imageNameFor:POMODORO]];
    self.recommendedActionButton.toolTip = @"Start a Pomodoro";
    self.recommendedActionBlock = ^(id sender) {[tmpSelf startPomodoro:sender];};

    self.startOption1Button.image = [NSImage imageNamed:[self.model.config imageNameFor:SHORT_BREAK]];
    self.startOption1Button.toolTip = @"Start a Short Break";
    self.startOption1Block = ^(id sender) {[tmpSelf startShortBreak:sender];};

    self.startOption2Button.image = [NSImage imageNamed:[self.model.config imageNameFor:LONG_BREAK]];
    self.startOption2Button.toolTip = @"Start a Long Break";
    self.startOption2Block = ^(id sender) {[tmpSelf startLongBreak:sender];};
  }
  }

  // Set hidden because, when the view appear, I'll decide if switch or not
  // to another view, based on the Auto-Mode flag.
  // I cannot do that because cannot switch view from didLoad (this view is not
  // replaced by the another but appended).
  [self.view setHidden:TRUE];
}
- (IBAction)startRecommended:(id)sender {
  NSLog(@"'Start Recommended' button pressed");
  self.recommendedActionBlock(sender);
}
- (IBAction)startOption1:(id)sender {
  NSLog(@"'Start Option1' button pressed");
  self.startOption1Block(sender);
}

- (IBAction)startOption2:(id)sender {
  NSLog(@"'Start Option2' button pressed");
  self.startOption2Block(sender);
}

- (IBAction)startPomodoro:(id)sender {
  [self.model startAPomodoro];
  id delegate = [NSApp delegate];
  [delegate switchToPomodoringView];
}

- (IBAction)startShortBreak:(id)sender {
  [self.model startAShortBreak];
  id delegate = [NSApp delegate];
  [delegate switchToPomodoringView];
}

- (IBAction)startLongBreak:(id)sender {
  [self.model startALongBreak];
  id delegate = [NSApp delegate];
  [delegate switchToPomodoringView];
}

- (IBAction)seeSummary:(id)sender {
  NSLog(@"'See Summary' button pressed");

  id delegate = [NSApp delegate];
  [delegate showRecordWindow];
}

@end
