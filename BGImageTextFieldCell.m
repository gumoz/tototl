//
//  BGImageTextFieldCell.m
//
//  Created by BinaryGod on 2/21/09.
//  Copyright 2009 none. All rights reserved.
//

#import "BGImageTextFieldCell.h"

@implementation BGImageTextFieldCell

- (void)drawInteriorWithFrame:(NSRect) rect inView:(NSView *) controlView {
	
	[super drawInteriorWithFrame: [(BGImageTextField *)controlView calculateTextFrame: rect] inView: controlView];
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
	
    [super editWithFrame: [(BGImageTextField *)controlView calculateTextFrame: aRect] inView: controlView editor:textObj delegate:anObject event: theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
	
    [super selectWithFrame: [(BGImageTextField *)controlView calculateTextFrame: aRect] inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

@end
