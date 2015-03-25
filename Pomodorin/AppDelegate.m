//
//  AppDelegate.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PomodoringViewController.h"
#import "DecideNextStepViewController.h"
#import "TodayStatus.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong,nonatomic) IBOutlet NSViewController* currentView;
@property (strong) TodayStatus* model;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.model = [[TodayStatus alloc] init];
    [self switchToMainView];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    self.model = nil;
}

- (void) switchToMainView {
    [self initAndSetAsCurrentView:[MainViewController alloc] withNibName:@"MainViewController"];
}

- (void) switchToPomodoringView {
    [self initAndSetAsCurrentView:[PomodoringViewController alloc] withNibName:@"PomodoringViewController"];
}

- (void) switchToDecideNextStepView {
    [self initAndSetAsCurrentView:[DecideNextStepViewController alloc] withNibName:@"DecideNextStepViewController"];
}


// HELPERS
- (void) initAndSetAsCurrentView:(NSViewController*)aView withNibName:(NSString*)nibName {
    // First remove the current view
    if (self.currentView) {
        [self.currentView.view removeFromSuperview];
    }
    
    // Then initialize and add the other view
    self.currentView = [aView initWithNibName:nibName bundle:nil];
    
    
    // For the controllers supporting my model object, set it up
    if ([self.currentView respondsToSelector:@selector(setModel:)])
    {
        id theView = self.currentView;
        [theView setModel:self.model];
    }
    
    // And now add the view, setting the adequated size
    [self.window.contentView addSubview:self.currentView.view];
    self.currentView.view.frame = ((NSView*)self.window.contentView).bounds;
}
@end
