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
#import "Config.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong,nonatomic) IBOutlet NSViewController* currentView;
@property (strong) TodayStatus* model;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Register myself as a notification delegate in order to configure the flags
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    self.model = [self loadModel];
    self.model.config = [self loadConfig];
    
    [self switchToMainView];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self saveModel:self.model];
    [self saveConfig:self.model.config];
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

/// PERSISTENCE
-(NSString*) modelArchivePath {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *archivePath= [myBundle pathForResource:@"model" ofType:@"dat"];
    NSLog(@"Model archive path: %@", archivePath );
    return archivePath;
    
}

-(NSString*) configArchivePath {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *archivePath= [myBundle pathForResource:@"config" ofType:@"json"];
    NSLog(@"Config archive path: %@", archivePath );
    return archivePath;
}

-(TodayStatus*) loadModel {
    NSLog(@"Loading the model...");
    TodayStatus* model = nil;
    NSString* archivePath = [self modelArchivePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        NSData* archiveData =[[NSFileManager defaultManager] contentsAtPath:archivePath];
        if ([archiveData length]) {
            model = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        }
    }
    
    if (!model) {
        model = [[TodayStatus alloc] init];
    }
    return model;
}

-(Config*) loadConfig {
    NSLog(@"Loading the config...");
    NSData *archiveData = [[NSFileManager defaultManager] contentsAtPath:[self configArchivePath]];
    NSDictionary *configDict = [NSJSONSerialization JSONObjectWithData:archiveData options:NSJSONReadingAllowFragments error:nil];
    Config* config = [[Config alloc] init];
    config.pomodoroLength = [configDict[@"pomodoroLength"] integerValue];
    config.shortBreakLength = [configDict[@"shortBreakLength"] integerValue];
    config.longBreakLength = [configDict[@"longBreakLength"] integerValue];
    
    return config;
}

-(void) saveModel:(TodayStatus*)model {
    NSLog(@"Saving the model");
    BOOL success = [NSKeyedArchiver archiveRootObject:model toFile:[self modelArchivePath]];
    NSLog(@"\tStatus code: %u", success);
}

-(void) saveConfig:(Config*)config {
    NSLog(@"Saving the config...");
    
    NSDictionary *configDict = @{
                                 @"pomodoroLength": [NSNumber numberWithInteger:config.pomodoroLength],
                                 @"shortBreakLength": [NSNumber numberWithInteger:config.shortBreakLength],
                                 @"longBreakLength": [NSNumber numberWithInteger:config.longBreakLength]
                                 };
    
    NSError *jsonError = [[NSError alloc] init];
    NSData *jsonFile = [NSJSONSerialization dataWithJSONObject:configDict options:NSJSONWritingPrettyPrinted error:&jsonError];
    if ([jsonError code]) {
        NSLog(@"Internal error while creating Json data for the config");
    }
    BOOL result = [jsonFile writeToFile:[self configArchivePath] atomically:YES];
    NSLog(@"\tStatus code: %u", result);
}

@end
