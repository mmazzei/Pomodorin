//
//  CurrentTask.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "TimeBox.h"

@implementation TimeBox

- (id) initWithType:(int) taskType expiringOn:(NSDate*)date {
    self = [super init];
    
    if (self) {
        _type = taskType;
        _expiresOn = date;
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    NSLog(@"Initing TimeBox with decoder");
    self = [super init];
    if (self) {
        _type = [decoder decodeIntForKey:@"type"];
        _expiresOn = [decoder decodeObjectForKey:@"expiresOn"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding TimeBox with coder");
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeObject:self.expiresOn forKey:@"expiresOn"];
}

- (BOOL) isExpired {
    return ([self.expiresOn compare:[NSDate date]] != NSOrderedDescending);
}

@end
