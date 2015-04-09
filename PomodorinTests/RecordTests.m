//
//  RecordTests.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "GlobalDeclarations.h"
#import "TestTimer.h"
#import "Pomodoro.h"
#import "Record.h"
#import "Summary.h"
#import "Config.h"

@interface RecordTests : XCTestCase
@end

@implementation RecordTests
- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSummaryForDateWithoutPomodorosIsZero {
  XCTAssert(YES, @"The summary for a date without pomodoros should be all zeros");
  Record* record = [[Record alloc] init];
  Summary* summary = [record summaryAt:[Timer.sharedInstance now]];
  XCTAssertEqual(summary.pomodoros, 0);
  XCTAssertEqual(summary.internalInterruptions, 0);
  XCTAssertEqual(summary.externalInterruptions, 0);
}

- (void)testAddPomodoroToDateWithoutSummary {
  XCTAssert(YES, @"Adding a pomodoro to a date without pomodoros should initialize the summary with the pomodoro.");
  Record* record = [[Record alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] init];
  pomodoro.internalInterruptions = 2;
  pomodoro.externalInterruptions = 3;
  [record add:pomodoro at:[Timer.sharedInstance now]];
  
  Summary* summary = [record summaryAt:[Timer.sharedInstance now]];
  XCTAssertEqual(summary.pomodoros, 1);
  XCTAssertEqual(summary.internalInterruptions, pomodoro.internalInterruptions);
  XCTAssertEqual(summary.externalInterruptions, pomodoro.externalInterruptions);
}

- (void)testAddPomodoroToDateWithSummary {
  XCTAssert(YES, @"Adding a pomodoro to a date with more pomodoros should update the summary.");
  Record* record = [[Record alloc] init];
  Pomodoro* pomodoro1 = [[Pomodoro alloc] init];
  pomodoro1.internalInterruptions = 2;
  pomodoro1.externalInterruptions = 3;
  [record add:pomodoro1 at:[Timer.sharedInstance now]];

  Pomodoro* pomodoro2 = [[Pomodoro alloc] init];
  pomodoro2.internalInterruptions = 5;
  pomodoro2.externalInterruptions = 9;
  [record add:pomodoro2 at:[Timer.sharedInstance now]];

  Summary* summary = [record summaryAt:[Timer.sharedInstance now]];
  XCTAssertEqual(summary.pomodoros, 2);
  XCTAssertEqual(summary.internalInterruptions, pomodoro1.internalInterruptions + pomodoro2.internalInterruptions);
  XCTAssertEqual(summary.externalInterruptions, pomodoro1.externalInterruptions + pomodoro2.externalInterruptions);
}

- (void)addingPomodorosAtDifferentDates {
  XCTAssert(YES, @"The addition of two pomodoros in different dates shouldn't be affect the same summary.");
  NSDate* today = [Timer.sharedInstance now];
  NSDate* yesterday = [today dateByAddingTimeInterval:-24*60*60];
  
  Record* record = [[Record alloc] init];
  Pomodoro* pomodoro1 = [[Pomodoro alloc] init];
  pomodoro1.internalInterruptions = 2;
  pomodoro1.externalInterruptions = 3;
  [record add:pomodoro1 at:yesterday];

  Pomodoro* pomodoro2 = [[Pomodoro alloc] init];
  pomodoro2.internalInterruptions = 5;
  pomodoro2.externalInterruptions = 9;
  [record add:pomodoro2 at:today];

  Summary* yesterdaySummary = [record summaryAt:yesterday];
  XCTAssertEqual(yesterdaySummary.pomodoros, 1);
  XCTAssertEqual(yesterdaySummary.internalInterruptions, pomodoro1.internalInterruptions);
  XCTAssertEqual(yesterdaySummary.externalInterruptions, pomodoro1.externalInterruptions);

  Summary* todaySummary = [record summaryAt:today];
  XCTAssertEqual(todaySummary.pomodoros, 1);
  XCTAssertEqual(todaySummary.internalInterruptions, pomodoro1.internalInterruptions);
  XCTAssertEqual(todaySummary.externalInterruptions, pomodoro1.externalInterruptions);
}
@end
