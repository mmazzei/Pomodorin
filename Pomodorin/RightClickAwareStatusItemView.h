//
//  RightClickAwareStatusItemView.h
//  Pomodorin
//
//  Created by Matias Mazzei on 4/5/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// This class is based on the following StackOverflow answer,
// from the user 'keegan3d':
//  - http://stackoverflow.com/a/6814017
// The idea is to provide support in the status bar item to
// right and left clicks, to allow open a menu with right click
// and open the window with left click.
@interface RightClickAwareStatusItemView : NSControl
@property (copy) NSImage* image;
@property (copy) NSImage* alternateImage;
@property (assign) SEL rightAction;
@end
