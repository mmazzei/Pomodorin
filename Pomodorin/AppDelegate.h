//
//  AppDelegate.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

- (void)switchToMainView;
- (void)switchToPomodoringView;
- (void)switchToDecideNextStepView;
- (void)showRecordWindow;
- (void)showPreferencesWindow;

@end
