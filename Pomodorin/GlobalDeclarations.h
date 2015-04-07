//
//  Header.h
//  Pomodorin
//
//  Created by Matias Mazzei on 3/27/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#ifndef Pomodorin_Header_h
#define Pomodorin_Header_h

// To avoid logs in the release versions
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) do {} while (0)
#endif

// To help do quick tests in debug versions (pomodoro lasts 25 seconds!)
#ifdef DEBUG
#define SECONDS_IN_A_MINUTE 1
#else
#define SECONDS_IN_A_MINUTE 60
#endif

// To allow run the debug app and the published one at the same time
#ifdef DEBUG
#define IS_THE_STATUS_ITEM_HIGHLIGHTED TRUE
#else
#define IS_THE_STATUS_ITEM_HIGHLIGHTED FALSE
#endif

#endif
