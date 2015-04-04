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
#import "Summary.h"

@interface RecordWindowController ()
@property(unsafe_unretained) IBOutlet NSTextView *recordText;

@end

@implementation RecordWindowController

- (void)windowDidLoad {
  [super windowDidLoad];
  if (self.model) {
    [self.recordText setString:[self.model.record print]];
  }
}

- (void)windowWillClose:(NSNotification *)notification {
  [NSApp stopModal];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.model.record.record count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

  NSString *key = self.model.record.record.allKeys[row];

  if ([tableColumn.identifier isEqualToString:@"date"]) {
    cellView.textField.stringValue = key;
    return cellView;
  }

  Summary *summary = self.model.record.record[key];

  if ([tableColumn.identifier isEqualToString:@"pomodoros"]) {
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", summary.pomodoros];
  } else if ([tableColumn.identifier isEqualToString:@"internalInterruptions"]) {
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", summary.internalInterruptions];
  } else if ([tableColumn.identifier isEqualToString:@"externalInterruptions"]) {
    cellView.textField.stringValue = [NSString stringWithFormat:@"%lu", summary.externalInterruptions];
  }

  return cellView;
}

@end
