//
//  PomodoringViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "PomodoringViewController.h"
#import "GlobalDeclarations.h"
#import "AppDelegate.h"

#import "TodayStatus.h"
#import "TimeBox.h"
#import "Record.h"
#import "Summary.h"
#import "Pomodoro.h"

@interface PomodoringViewController ()
@property (strong) NSTimer* refreshStatusTimer;
@property (strong) NSUserNotification* scheduledNotification;

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
    
    [self scheduleNotificationForTheEndOfCurrentTask];
}

- (void) viewDidDisappear {
    [self.refreshStatusTimer invalidate];
    [super viewDidDisappear];
}

- (void) viewDidAppear {
    [super viewDidAppear];

    [self.refreshStatusTimer invalidate];
    [self startTimer];
}

- (void) startTimer
{
    self.refreshStatusTimer = [NSTimer timerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(timerTick:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.refreshStatusTimer forMode:NSRunLoopCommonModes];
    
    // small hack (yeah) to initialize the display with the adequated values
    [self timerTick:self.refreshStatusTimer];
}

- (void)timerTick:(NSTimer *)timer
{
    NSLog(@"Timer tick");
    
    if ([self.model.currentTask isExpired]) {
        // And jump to a view to decide what to do next
        id delegate = [NSApp delegate];
        [delegate switchToDecideNextStepView];
    }
    else {
        // Get the time for the current task expiration
        NSDate* now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *difference = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond)
                                                   fromDate:now
                                                     toDate:self.model.currentTask.expiresOn
                                                    options:0];
        NSInteger minutes = [difference minute];
        NSInteger seconds = [difference second];
        NSLog(@"\t\tRemaining time: %2ld:%02ld", minutes, seconds);
        
        NSString *dateString = [NSString stringWithFormat:@"%2ld:%02ld",minutes,seconds];
        [self.timerLabel setStringValue:dateString];
    }
}


- (void) scheduleNotificationForTheEndOfCurrentTask {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Timer finished!";
    // notification.informativeText = [NSString stringWithFormat:@"bla bla bla"];
    notification.soundName = @"Glass";
    notification.deliveryDate = self.model.currentTask.expiresOn;
    notification.contentImage = self.currentTaskImage.image;
    
    // An unique Id is needed to allow the notif. center to remove from schedule if needed
    notification.identifier = [NSString stringWithFormat:@"pomodorin-%lu", self.model.currentTask.expiresOn.hash];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
    self.scheduledNotification = notification;
}

- (void) cancelScheduledNotification {
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:self.scheduledNotification];
    self.scheduledNotification = nil;
}

- (IBAction)discardTimebox:(id)sender {
    NSLog(@"'Discard Timebox' button pressed");
    [self.model discardCurrentTimebox];
    [self cancelScheduledNotification];
    
    id delegate = [NSApp delegate];
    [delegate switchToDecideNextStepView];
}

- (IBAction)addInternalInterruption:(id)sender {
    NSLog(@"'Add Internal Interruption' button pressed");
    Pomodoro* currentPomodoro = (Pomodoro*) self.model.currentTask;
    currentPomodoro.internalInterruptions++;
    [self.internalInterruptionsLabel setTitle:[NSString stringWithFormat:@"%d",currentPomodoro.internalInterruptions]];
}

- (IBAction)addExternalInterruption:(id)sender {
    NSLog(@"'Add External Interruption' button pressed");
    Pomodoro* currentPomodoro = (Pomodoro*) self.model.currentTask;
    currentPomodoro.externalInterruptions++;
    [self.externalInterruptionsLabel setTitle:[NSString stringWithFormat:@"%d",currentPomodoro.externalInterruptions]];
}
@end
