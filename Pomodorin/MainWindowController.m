//
//  MainWindowController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/6/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "MainWindowController.h"
#import "MainViewController.h"
#import "PomodoringViewController.h"
#import "DecideNextStepViewController.h"

#import "TodayStatus.h"
#import "TimeBox.h"

@interface MainWindowController ()
@property(strong, nonatomic) IBOutlet NSViewController *currentView;

@end

@implementation MainWindowController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  NSLog(@"Add as observer");
  [self.model addObserver:self forKeyPath:@"currentTask" options:NSKeyValueObservingOptionNew context:nil];
  
  // TODO - Execute the following on window close:
  //   [self.model removeObserver:self forKeyPath:@"currentTask" context:nil];

  // When starting the app, if there are a valid current task, show
  // the pomodoring view, it will seems as if the app was never closed
  if (self.model.currentTask && ![self.model.currentTask isExpired]) {
    [self switchToPomodoringView];
  } else {
    [self switchToMainView];
  }
}

- (void)observeValueForKeyPath:(NSString*) path ofObject:(NSObject*) object change:(NSDictionary*) change context:(void*) context {
  NSLog(@"Main window controller notified about model change");
  if (self.model.currentTask) {
    [self switchToPomodoringView];
  }
  else {
    [self switchToDecideNextStepView];
  }
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

// HELPERS
- (void)initAndSetAsCurrentView:(NSViewController *)aView
                    withNibName:(NSString *)nibName {
  NSLog(@"Switching to view %@", nibName);
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
  self.currentView.view.frame = ((NSView *)self.window.contentView).bounds;
  [self.window.contentView addSubview:self.currentView.view];
}

@end
