//
//  RecordWindowController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/26/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "RecordWindowController.h"
#import "GlobalDeclarations.h"

#import "TodayStatus.h"
#import "Record.h"

@interface RecordWindowController ()
@property (unsafe_unretained) IBOutlet NSTextView *recordText;

@end

@implementation RecordWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    if (self.model) {
        [self.recordText setString:[self.model.record print]];
    }
}


- (void)windowWillClose:(NSNotification*)notification
{
    [NSApp stopModal];
}

@end
