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
#import "RecordWindowController.h"
#import "PreferencesWindowController.h"
#import "TodayStatus.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong,nonatomic) IBOutlet NSViewController* currentView;
@property (strong) TodayStatus* model;
@end

@implementation AppDelegate

-(NSString*) archivePath {
    // Determining archive URL
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *archivePath= [myBundle pathForResource:@"config" ofType:@"cfg"];
    
    NSLog(@"Archive path: %@", archivePath );
    return archivePath;
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Register myself as a notification delegate in order to configure the flags
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

    NSLog(@"Loading the model...");
    self.model =  [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];

    [self switchToMainView];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    NSLog(@"Storing model");
    BOOL success = [NSKeyedArchiver archiveRootObject:self.model toFile:[self archivePath]];
    NSLog(@"\tStatus code: %u", success);
    self.model = nil;
}


// To allow click on the Dock icon, re-open the last window
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    
    [self.window makeKeyAndOrderFront:self];
    
    return YES;
}

// Flag to activate the notification popup
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

// "Preferences" menu item activated.
- (IBAction)showPreferences:(id)sender {
    [self showPreferencesWindow];
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

- (void) showRecordWindow {
    [self initAndShowWindow:[RecordWindowController alloc] withNibName:@"RecordWindowController"];
}

- (void) showPreferencesWindow {
    [self initAndShowWindow:[PreferencesWindowController alloc] withNibName:@"PreferencesWindowController"];
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

- (void) initAndShowWindow:(NSWindowController*)theWindow withNibName:(NSString*)nibName {
    theWindow = [theWindow initWithWindowNibName:nibName];
    
    // For the controllers supporting my model object, set it up
    if ([theWindow respondsToSelector:@selector(setModel:)])
    {
        id aWindow = theWindow;
        [aWindow setModel:self.model];
    }
    
    [NSApp runModalForWindow:[theWindow window]];
}
@end
