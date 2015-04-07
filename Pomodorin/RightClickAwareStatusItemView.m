//
//  RightClickAwareStatusItemView.m
//  Pomodorin
//
//  Created by Matias Mazzei on 4/5/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "RightClickAwareStatusItemView.h"
#include "GlobalDeclarations.h"

@implementation RightClickAwareStatusItemView
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize action = _action;
@synthesize rightAction = _rightAction;
@synthesize target = _target;

- (void)drawImage:(NSImage *)aImage centeredInRect:(NSRect)aRect{
  NSRect imageRect = NSMakeRect((CGFloat)round(aRect.size.width*0.5f-aImage.size.width*0.5f),
                                (CGFloat)round(aRect.size.height*0.5f-aImage.size.height*0.5f),
                                aImage.size.width,
                                aImage.size.height);
  if (IS_THE_STATUS_ITEM_HIGHLIGHTED) {
    [[NSColor greenColor] set];
    NSRectFill(aRect);
  }
  [aImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

- (void)drawRect:(NSRect)rect{
  [self drawImage:self.image centeredInRect:rect];
}

- (void)mouseDown:(NSEvent *)theEvent{
  [super mouseDown:theEvent];

  if ([theEvent modifierFlags] & NSCommandKeyMask){
    [self.target performSelectorOnMainThread:self.rightAction withObject:nil waitUntilDone:NO];
  }else{
    [self.target performSelectorOnMainThread:self.action withObject:nil waitUntilDone:NO];
  }
}

- (void)rightMouseDown:(NSEvent *)theEvent{
  [super rightMouseDown:theEvent];
  [self.target performSelectorOnMainThread:self.rightAction withObject:nil waitUntilDone:NO];
}

@end
