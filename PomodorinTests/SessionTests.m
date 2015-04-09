//
//  SessionTests.m
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
#import "ShortBreak.h"
#import "LongBreak.h"
#import "Session.h"
#import "Config.h"

@interface SessionTests : XCTestCase
@property (strong) Config* config;
@property (strong) TestTimer* timer;
@end

@implementation SessionTests
- (void)setUp {
  self.timer = [[TestTimer alloc] init];
  Timer.sharedInstance.delegate = self.timer;
  
  self.config = [[Config alloc] init];
  self.config.pomodoroLength = 1;
  self.config.shortBreakLength = 2;
  self.config.longBreakLength = 4;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testEmptySessionAgeIsZero {
  XCTAssert(YES, @"The age in minutes for an empty session is zero");
  Session* session = [[Session alloc] init];
  XCTAssertEqual(session.ageInMinutes, 0);
}

- (void)testNotEmptySessionAgeIsTheSameAsTimeboxAge {
  XCTAssert(YES, @"The age in minutes for a session with only one timebox is the age of that timebox");
  NSUInteger intendedAge = 5;
  Session* session = [[Session alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  [session add:pomodoro];
  [self.timer advance:(self.config.pomodoroLength+intendedAge)*SECONDS_IN_A_MINUTE];

  XCTAssertEqual(session.ageInMinutes, intendedAge);
}

- (void)testNotEmptySessionAgeIsTheSameAsNewestTimeboxAge {
  XCTAssert(YES, @"The age in minutes for a session with more than one timebox is the age of the last added timebox");
  NSUInteger intendedAge = 3;
  Session* session = [[Session alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  [session add:pomodoro];
  [self.timer advance:(self.config.pomodoroLength+1)*SECONDS_IN_A_MINUTE];
  
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  [session add:shortBreak];
  [self.timer advance:(self.config.shortBreakLength+intendedAge)*SECONDS_IN_A_MINUTE];
  
  XCTAssertEqual(session.ageInMinutes, intendedAge);
}

- (void)testRecommendPomodoroForEmptySession {
  XCTAssert(YES, @"The recommended for an empty session is a Pomodoro");
  Session* session = [[Session alloc] init];
  XCTAssertEqual(session.recommendedTimebox.type, POMODORO);
}

- (void)testRecommendPomodoroAfterShortBreak {
  XCTAssert(YES, @"The recommended for a session finishing in a short break is a Pomodoro");

  Session* session = [[Session alloc] init];
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  [session add:shortBreak];
  
  XCTAssertEqual(session.recommendedTimebox.type, POMODORO);

}

- (void)testRecommendPomodoroAfterLongBreak {
  XCTAssert(YES, @"The recommended for a session finishing in a long break is a Pomodoro");

  Session* session = [[Session alloc] init];
  LongBreak* longBreak = [[LongBreak alloc] initWithConfig:self.config];
  [session add:longBreak];
  
  XCTAssertEqual(session.recommendedTimebox.type, POMODORO);
}

- (void)testRecommendLongBreakAfterPSPSPSPPattern {
  XCTAssert(YES, @"The recommended for a session following the P-S-P-S-P-S-P pattern is a long break");

  Session* session = [[Session alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  
  // To be sure we are adding only expired timeboxes to the session
  [self.timer advance:self.config.pomodoroLength];
  [self.timer advance:self.config.shortBreakLength];

  [session add:pomodoro];
  [session add:shortBreak];
  [session add:pomodoro];
  [session add:shortBreak];
  [session add:pomodoro];
  [session add:shortBreak];
  [session add:pomodoro];

  XCTAssertEqual(session.recommendedTimebox.type, LONG_BREAK);
}

- (void)testRecommendShortBreakAfterPomodoroIfNotPSPSPSPPattern {
  XCTAssert(YES, @"The recommended for a session not following the P-S-P-S-P-S-P pattern is a short break");

  
  Session* session = [[Session alloc] init];
  Pomodoro* pomodoro = [[Pomodoro alloc] initWithConfig:self.config];
  ShortBreak* shortBreak = [[ShortBreak alloc] initWithConfig:self.config];
  
  // To be sure we are adding only expired timeboxes to the session
  [self.timer advance:self.config.pomodoroLength];
  [self.timer advance:self.config.shortBreakLength];
  
  [session add:pomodoro];
  [session add:shortBreak];
  [session add:pomodoro];
  [session add:shortBreak];
  [session add:pomodoro];
  [session add:pomodoro];
  [session add:pomodoro];
  
  XCTAssertEqual(session.recommendedTimebox.type, SHORT_BREAK);
}

@end
