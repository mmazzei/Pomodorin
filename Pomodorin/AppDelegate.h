//
//  AppDelegate.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>


- (void) switchToMainView;
- (void) switchToPomodoringView;
- (void) switchToDecideNextStepView;
- (void) switchToRecordViewController;

@end

