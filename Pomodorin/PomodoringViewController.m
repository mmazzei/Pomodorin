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
@property (weak) IBOutlet NSImageView *currentTaskImage;

@property (weak) IBOutlet NSButton *internalInterruptionsLabel;
@property (weak) IBOutlet NSButton *externalInterruptionsLabel;
@property (weak) IBOutlet NSBox *interruptionsBox;

@end

@implementation PomodoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.model.currentTask.type) {
        case POMODORO:
            [self.currentTaskImage setImage:[NSImage imageNamed:@"tomato"]];
            break;
        case SHORT_BREAK:
            [self.currentTaskImage setImage:[NSImage imageNamed:@"hourglass"]];
            [self.interruptionsBox removeFromSuperview];
            break;
        case LONG_BREAK:
            [self.currentTaskImage setImage:[NSImage imageNamed:@"dark_hourglass"]];
            [self.interruptionsBox removeFromSuperview];
            break;
        default:
            [self.currentTaskImage setImage:[NSImage imageNamed:@"tomato"]];
            break;
    }
    
    [self startTimer];
}

- (void) viewDidDisappear {
    [self.refreshStatusTimer invalidate];
    [super viewDidDisappear];
}

- (void) viewDidAppear {
    [self.refreshStatusTimer invalidate];
    [self startTimer];
    [super viewDidAppear];
}

- (void) startTimer
{
    self.refreshStatusTimer = [NSTimer timerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(timerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.refreshStatusTimer forMode:NSRunLoopCommonModes];
    [self timerTick:self.refreshStatusTimer];
}

- (void)timerTick:(NSTimer *)timer
{
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
        // Send a system notification
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Timer finished!";
        // notification.informativeText = [NSString stringWithFormat:@"bla bla bla"];
        notification.soundName = @"Glass";
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        // And jump to a view to decide what to do next
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
    [self.internalInterruptionsLabel setTitle:[NSString stringWithFormat:@"%d",currentPomodoro.internalInterruptions]];
}

- (IBAction)addExternalInterruption:(id)sender {
    NSLog(@"Add external interruption button pressed");
    Pomodoro* currentPomodoro = (Pomodoro*) self.model.currentTask;
    currentPomodoro.externalInterruptions++;
    [self.externalInterruptionsLabel setTitle:[NSString stringWithFormat:@"%d",currentPomodoro.externalInterruptions]];
}

- (IBAction)stopPomodoring:(id)sender {
    NSLog(@"Stop pomodoring button pressed");
    [self.model discardCurrentTimebox];
    
    id delegate = [NSApp delegate];
    [delegate switchToMainView];
}

@end
