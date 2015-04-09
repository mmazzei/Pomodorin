//
//  PomodoroTests.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GlobalDeclarations.h"
#import "TestTimer.h"
#import "Pomodoro.h"
#import "Config.h"

@interface PomodoroTests : XCTestCase
@property (strong) Config* config;
@property (strong) TestTimer* timer;
@end

@implementation PomodoroTests
- (void)setUp {
  [super setUp];
  self.timer = [[TestTimer alloc] init];
  Timer.sharedInstance.delegate = self.timer;
  
  self.config = [[Config alloc] init];
  self.config.pomodoroLength = 5;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testPomodoroIsExpiredAfterEllapsedInterval {
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  [self.timer advance:self.config.pomodoroLength*SECONDS_IN_A_MINUTE];
  
  XCTAssert([pomodoro isExpired], @"The pomodoro should be expired here.");
}

- (void)testPomodoroIsNotExpiredBeforeEllapsedInterval {
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  [self.timer advance:1];

  XCTAssert(! [pomodoro isExpired], @"The pomodoro should not be expired here.");
}
@end
