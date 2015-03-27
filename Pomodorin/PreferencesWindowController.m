//
//  PreferencesWindowController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "TodayStatus.h"
#import "Config.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.pomodoroLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.pomodoroLength];
    self.shortBreakLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.shortBreakLength];
    self.longBreakLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.longBreakLength];
    
    self.pomodoroSlider.integerValue = self.model.config.pomodoroLength;
    self.shortBreakSlider.integerValue = self.model.config.shortBreakLength;
    self.longBreakSlider.integerValue = self.model.config.longBreakLength;
}

- (void)windowWillClose:(NSNotification*)notification
{
    [NSApp stopModal];
}

- (IBAction)updatePomodoroLength:(id)sender {
    self.model.config.pomodoroLength = [self.pomodoroSlider integerValue];
    self.pomodoroLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.pomodoroLength];
}

- (IBAction)updateShortBreakLength:(id)sender {
    self.model.config.shortBreakLength = [self.shortBreakSlider integerValue];
    self.shortBreakLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.shortBreakLength];
}

- (IBAction)updateLongBreakLength:(id)sender {
    self.model.config.longBreakLength = [self.longBreakSlider integerValue];
    self.longBreakLabel.stringValue = [NSString stringWithFormat:@"%ld min", self.model.config.longBreakLength];
}
@end
