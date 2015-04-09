//
//  SummaryTests.m
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
#import "Summary.h"
#import "Config.h"

@interface SummaryTests : XCTestCase
@end

@implementation SummaryTests
- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testSummaryCountersSetsAccordinglyForTheFirstPomodoro {
  Summary* summary = [[Summary alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] init];
  pomodoro.internalInterruptions = 2;
  pomodoro.externalInterruptions = 3;
  [summary add:pomodoro];

  XCTAssertEqual(summary.pomodoros, 1);
  XCTAssertEqual(summary.internalInterruptions, pomodoro.internalInterruptions);
  XCTAssertEqual(summary.externalInterruptions, pomodoro.externalInterruptions);
}

- (void)testSummaryCountersUpdatesAccordinglyWhenAddedANewPomodoro {
  Summary* summary = [[Summary alloc] init];

  Pomodoro* pomodoro1 = [[Pomodoro alloc] init];
  pomodoro1.internalInterruptions = 2;
  pomodoro1.externalInterruptions = 3;
  [summary add:pomodoro1];

  Pomodoro* pomodoro2 = [[Pomodoro alloc] init];
  pomodoro2.internalInterruptions = 5;
  pomodoro2.externalInterruptions = 6;
  [summary add:pomodoro2];

  XCTAssertEqual(summary.pomodoros, 2);
  XCTAssertEqual(summary.internalInterruptions, pomodoro1.internalInterruptions + pomodoro2.internalInterruptions);
  XCTAssertEqual(summary.externalInterruptions, pomodoro1.externalInterruptions + pomodoro2.externalInterruptions);
}
@end
