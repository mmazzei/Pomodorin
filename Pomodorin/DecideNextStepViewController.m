//
//  DecideNextStepViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "DecideNextStepViewController.h"
#import "AppDelegate.h"
#import "TodayStatus.h"
#import "Record.h"

@interface DecideNextStepViewController ()

@end

@implementation DecideNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)startPomodoro:(id)sender {
    NSLog(@"'Start Pomodoro' button pressed");
    [self.model startAPomodoro];
    
    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)startShortBreak:(id)sender {
    NSLog(@"'Start Short Break' button pressed");
    [self.model startAShortBreak];

    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)startLongBreak:(id)sender {
    NSLog(@"'Start Long Break' button pressed");
    [self.model startALongBreak];

    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)stopPomodoring:(id)sender {
    NSLog(@"Stop pomodoring button pressed");
    [self.model discardCurrentTimebox];
    
    id delegate = [NSApp delegate];
    [delegate switchToMainView];
}

- (IBAction)seeSummary:(id)sender {
    NSLog(@"'See Summary' button pressed");
    
    id delegate = [NSApp delegate];
    [delegate showRecordWindow];
}

@end
