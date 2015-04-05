//
//  AppDelegate.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalDeclarations.h"
#import "MainViewController.h"
#import "PomodoringViewController.h"
#import "DecideNextStepViewController.h"
#import "RecordWindowController.h"
#import "PreferencesWindowController.h"
#import "RightClickAwareStatusItemView.h"
#import "TodayStatus.h"
#import "TimeBox.h"
#import "Config.h"

@interface AppDelegate ()

@property(weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *menu;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property(strong, nonatomic) IBOutlet NSViewController *currentView;
@property(strong) TodayStatus *model;
@property (strong) RightClickAwareStatusItemView* statusItemView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Configure the status item with the custom control
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
  self.statusItemView = [[RightClickAwareStatusItemView alloc] init];
  self.statusItemView.image = [NSImage imageNamed:@"tomato"];
  self.statusItemView.target = self;
  self.statusItemView.action = @selector(statusItemAction:);
  self.statusItemView.rightAction = @selector(showStatusItemMenu);
  [self.statusItem setView:self.statusItemView];
  
  // Register myself as a notification delegate in order to configure the flags
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  self.model = [self loadModel];
  self.model.config = [self loadConfig];

  // When starting the app, if there are a valid current task, show
  // the pomodoring view, it will seems as if the app was never closed
  if (self.model.currentTask && ![self.model.currentTask isExpired]) {
    [self switchToPomodoringView];
  } else {
    [self switchToMainView];
  }
}

// Shows the menu
- (void)showStatusItemMenu{
  [self.statusItem popUpStatusItemMenu:self.menu];
}

// Shows/Hides the main window
- (void)statusItemAction:(id)sender {
  NSWindow *aWindow = [self window];
  NSApplication *myApp = [NSApplication sharedApplication];
  if (![aWindow isKeyWindow]) {
    [aWindow makeKeyAndOrderFront:self];
    [myApp activateIgnoringOtherApps:YES];
    [aWindow orderFrontRegardless];
  }
  else{
    if ([myApp isActive]){
      // Hide the window
      [aWindow orderOut:sender];
    }
    else{
      // Display the window
      [myApp activateIgnoringOtherApps:YES];
      [aWindow orderFrontRegardless];
    }
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  [self saveModel:self.model];
  [self saveConfig:self.model.config];
  self.model = nil;
}

// To allow click on the Dock icon, re-open the last window
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag {
  if (!flag) {
    [self.window makeKeyAndOrderFront:self];
  }

  return flag;
}

// Flag to activate the notification popup
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification {
  return YES;
}

// When coming from the notification, maximize the window
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification {
  // This is to avoid the segmentation fault for the case
  // of minimized app -> notification -> user clicks notificaction
  //  -> nothing happens -> user maximizes the app -> segmentation fault
  if ([self.model.currentTask isExpired]) {
    [self switchToDecideNextStepView];
  }
  [[self window] deminiaturize:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
        (NSApplication *)theApplication {
  return NO;
}

// Sent to the delegate when a notification delivery date has arrived.
- (void)userNotificationCenter:(NSUserNotificationCenter *)center
        didDeliverNotification:(NSUserNotification *)notification {
  if ([self.window isMiniaturized]) {
    [self switchToPomodoringView];
    [self.window deminiaturize:self];
  }
}

// "Preferences" menu item activated.
- (IBAction)showPreferences:(id)sender {
  [self showPreferencesWindow];
}

- (void)switchToMainView {
  [self initAndSetAsCurrentView:[MainViewController alloc]
                    withNibName:@"MainViewController"];
}

- (void)switchToPomodoringView {
  [self initAndSetAsCurrentView:[PomodoringViewController alloc]
                    withNibName:@"PomodoringViewController"];
}

- (void)switchToDecideNextStepView {
  [self initAndSetAsCurrentView:[DecideNextStepViewController alloc]
                    withNibName:@"DecideNextStepViewController"];
}

- (void)showRecordWindow {
  [self initAndShowWindow:[RecordWindowController alloc]
              withNibName:@"RecordWindowController"];
}

- (void)showPreferencesWindow {
  [self initAndShowWindow:[PreferencesWindowController alloc]
              withNibName:@"PreferencesWindowController"];
}

// HELPERS
- (void)initAndSetAsCurrentView:(NSViewController *)aView
                    withNibName:(NSString *)nibName {
  // First remove the current view
  if (self.currentView) {
    [self.currentView.view removeFromSuperview];
  }

  // Then initialize and add the other view
  self.currentView = [aView initWithNibName:nibName bundle:nil];

  // For the controllers supporting my model object, set it up
  if ([self.currentView respondsToSelector:@selector(setModel:)]) {
    id theView = self.currentView;
    [theView setModel:self.model];
  }

  // And now add the view, setting the adequated size
  [self.window.contentView addSubview:self.currentView.view];
  self.currentView.view.frame = ((NSView *)self.window.contentView).bounds;
}

- (void)initAndShowWindow:(NSWindowController *)theWindow
              withNibName:(NSString *)nibName {
  theWindow = [theWindow initWithWindowNibName:nibName];

  // For the controllers supporting my model object, set it up
  if ([theWindow respondsToSelector:@selector(setModel:)]) {
    id aWindow = theWindow;
    [aWindow setModel:self.model];
  }

  [NSApp runModalForWindow:[theWindow window]];
}

/// PERSISTENCE
- (NSString *)modelArchivePath {
  NSBundle *myBundle = [NSBundle mainBundle];
  NSString *archivePath = [myBundle pathForResource:@"model" ofType:@"dat"];
  NSLog(@"Model archive path: %@", archivePath);
  return archivePath;
}

- (NSString *)configArchivePath {
  NSBundle *myBundle = [NSBundle mainBundle];
  NSString *archivePath = [myBundle pathForResource:@"config" ofType:@"json"];
  NSLog(@"Config archive path: %@", archivePath);
  return archivePath;
}

- (TodayStatus *)loadModel {
  NSLog(@"Loading the model...");
  TodayStatus *model = nil;
  NSString *archivePath = [self modelArchivePath];

  if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
    NSData *archiveData = [[NSFileManager defaultManager] contentsAtPath:archivePath];
    if ([archiveData length]) {
      model = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    }
  }

  if (!model) {
    model = [[TodayStatus alloc] init];
  }
  return model;
}

- (Config *)loadConfig {
  NSLog(@"Loading the config...");
  NSData *archiveData = [[NSFileManager defaultManager] contentsAtPath:[self configArchivePath]];
  NSDictionary *configDict =
      [NSJSONSerialization JSONObjectWithData:archiveData
                                      options:NSJSONReadingAllowFragments
                                        error:nil];
  Config *config = [[Config alloc] init];
  config.pomodoroLength = [configDict[@"pomodoroLength"] integerValue];
  config.shortBreakLength = [configDict[@"shortBreakLength"] integerValue];
  config.longBreakLength = [configDict[@"longBreakLength"] integerValue];

  return config;
}

- (void)saveModel:(TodayStatus *)model {
  NSLog(@"Saving the model");
  BOOL success =
      [NSKeyedArchiver archiveRootObject:model toFile:[self modelArchivePath]];
  NSLog(@"\tStatus code: %u", success);
}

- (void)saveConfig:(Config *)config {
  NSLog(@"Saving the config...");

  NSDictionary *configDict = @{
    @"pomodoroLength" : [NSNumber numberWithInteger:config.pomodoroLength],
    @"shortBreakLength" : [NSNumber numberWithInteger:config.shortBreakLength],
    @"longBreakLength" : [NSNumber numberWithInteger:config.longBreakLength]
  };

  NSError *jsonError = [[NSError alloc] init];
  NSData *jsonFile =
      [NSJSONSerialization dataWithJSONObject:configDict
                                      options:NSJSONWritingPrettyPrinted
                                        error:&jsonError];
  if ([jsonError code]) {
    NSLog(@"Internal error while creating Json data for the config");
  }
  BOOL result = [jsonFile writeToFile:[self configArchivePath] atomically:YES];
  NSLog(@"\tStatus code: %u", result);
}

@end
