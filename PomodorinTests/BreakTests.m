//
//  BreakTests.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/8/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "GlobalDeclarations.h"
#import "TestTimer.h"
#import "ShortBreak.h"
#import "LongBreak.h"
#import "Config.h"

@interface BreakTests : XCTestCase
@property (strong) Config* config;
@property (strong) TestTimer* timer;
@end

@implementation BreakTests
- (void)setUp {
  [super setUp];
  self.timer = [[TestTimer alloc] init];
  Timer.sharedInstance.delegate = self.timer;
  
  self.config = [[Config alloc] init];
  self.config.shortBreakLength = 5;
  self.config.longBreakLength = 5;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testShortBreakIsExpiredAfterEllapsedInterval {
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  [self.timer advance:self.config.shortBreakLength*SECONDS_IN_A_MINUTE];
  
  XCTAssert([shortBreak isExpired], @"The break should be expired here.");
}

- (void)testShortBreakIsNotExpiredBeforeEllapsedInterval {
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  [self.timer advance:1];
  
  XCTAssert(![shortBreak isExpired], @"The break should not be expired here.");
}

- (void)testLongBreakIsExpiredAfterEllapsedInterval {
  LongBreak* longBreak = [[LongBreak alloc] initWithConfig:self.config];
  [self.timer advance:self.config.longBreakLength*SECONDS_IN_A_MINUTE];
  
  XCTAssert([longBreak isExpired], @"The break should be expired here.");
}

- (void)testLongBreakIsNotExpiredBeforeEllapsedInterval {
  LongBreak* longBreak = [[LongBreak alloc] initWithConfig:self.config];
  [self.timer advance:1];
  
  XCTAssert(![longBreak isExpired], @"The break should not be expired here.");
}
@end
