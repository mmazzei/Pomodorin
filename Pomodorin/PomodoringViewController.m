//
//  PomodoringViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "PomodoringViewController.h"
#import "AppDelegate.h"

#import "TodayStatus.h"
#import "TimeBox.h"
#import "Record.h"
#import "Summary.h"
#import "Pomodoro.h"

@interface PomodoringViewController ()
@property (strong) NSTimer* refreshStatusTimer;

@property (weak) IBOutlet NSTextField *timerLabel;
@property (weak) IBOutlet NSTextField *pomodoroTypeLabel;
@property (weak) IBOutlet NSTextField *summaryLabel;

@end

@implementation PomodoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.model.currentTask.type) {
        case POMODORO:
            [self.pomodoroTypeLabel setStringValue:@"Pomodoro"];
            break;
        case SHORT_BREAK:
            [self.pomodoroTypeLabel setStringValue:@"Short Break"];
            break;
        case LONG_BREAK:
            [self.pomodoroTypeLabel setStringValue:@"Long Break"];
            break;
                    default:
            [self.pomodoroTypeLabel setStringValue:@"INVALID"];
            break;
    }
    
    [self.summaryLabel setStringValue:[NSString stringWithFormat:@"#%lu",[self.model.record summaryAt:[NSDate date]].pomodoros ] ];
    [self startTimer];
}

- (void) viewDidDisappear {
    [self.refreshStatusTimer invalidate];
    [super viewDidDisappear];
}

- (void) startTimer
{
    self.refreshStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(timerTick:)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)timerTick:(NSTimer *)timer
{
    //NSLog(@"Timer tick");

    // Get the time for the current task expiration
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond)
                                                fromDate:now
                                                  toDate:self.model.currentTask.expiresOn
                                                options:0];
    NSInteger minutes = [difference minute];
    NSInteger seconds = [difference second];

    NSString *dateString = [NSString stringWithFormat:@"%2ld:%02ld",minutes,seconds];
    [self.timerLabel setStringValue:dateString];
    
    if ([self.model.currentTask isExpired]) {
        id delegate = [NSApp delegate];
        [delegate switchToDecideNextStepView];
    }
}

- (IBAction)discardTimebox:(id)sender {
    NSLog(@"Discard timebox button pressed");
    [self.model discardCurrentTimebox];

    id delegate = [NSApp delegate];
    [delegate switchToDecideNextStepView];
}

- (IBAction)addInternalInterruption:(id)sender {
    NSLog(@"Add internal interruption button pressed");
    Pomodoro* currentPomodoro = (Pomodoro*) self.model.currentTask;
    currentPomodoro.internalInterruptions++;
}

- (IBAction)addExternalInterruption:(id)sender {
    NSLog(@"Add external interruption button pressed");
    Pomodoro* currentPomodoro = (Pomodoro*) self.model.currentTask;
    currentPomodoro.externalInterruptions++;
}

- (IBAction)stopPomodoring:(id)sender {
    NSLog(@"Stop pomodoring button pressed");
    [self.model discardCurrentTimebox];
    
    id delegate = [NSApp delegate];
    [delegate switchToMainView];
}

- (IBAction)seeSummary:(id)sender {
    NSLog(@"See summary button pressed");
    [self.model.record print];
}

@end
