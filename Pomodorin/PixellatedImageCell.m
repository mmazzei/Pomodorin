//
//  PixellatedImageCell.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/5/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "PixellatedImageCell.h"

@implementation PixellatedImageCell
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
  [[NSGraphicsContext currentContext] saveGraphicsState];

  [[NSGraphicsContext currentContext]
      setImageInterpolation:NSImageInterpolationNone];
  [super drawInteriorWithFrame:cellFrame inView:controlView];

  [[NSGraphicsContext currentContext] restoreGraphicsState];
}
@end
