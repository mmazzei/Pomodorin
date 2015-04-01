//
//  JSONCompatible.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/1/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#ifndef Pomodorin_JSONCompatible_h
#define Pomodorin_JSONCompatible_h

#import <Foundation/Foundation.h>

@protocol JSONCompatible <NSObject>
-(NSDictionary*) toDictionary;
-(id) fromDictionary:(NSDictionary*) dictionary;
@end

#endif
