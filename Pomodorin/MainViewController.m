//
//  MainViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "MainViewController.h"
#import "GlobalDeclarations.h"
#import "AppDelegate.h"

#import "TodayStatus.h"
#import "Record.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)startPomodoring:(id)sender {
  NSLog(@"'Start Pomodoring' button pressed");
  [self.model startAPomodoro];
}

- (IBAction)seeSummary:(id)sender {
  NSLog(@"See Summary' button pressed");
  id delegate = [NSApp delegate];
  [delegate showRecordWindow];
}

@end
