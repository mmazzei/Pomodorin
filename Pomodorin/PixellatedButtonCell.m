//
//  PixellatedButtonCell.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/5/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "PixellatedButtonCell.h"

@implementation PixellatedButtonCell
- (void)drawImage:(NSImage *)image
        withFrame:(NSRect)frame
           inView:(NSView *)controlView {
  [[NSGraphicsContext currentContext] saveGraphicsState];

  [[NSGraphicsContext currentContext]
      setImageInterpolation:NSImageInterpolationNone];
  [super drawImage:image withFrame:frame inView:controlView];

  [[NSGraphicsContext currentContext] restoreGraphicsState];
}
@end
