//
//  BGImageTextField.m
//  
//
//  Created by BinaryGod on 2/21/09.
//  Copyright 2009 none. All rights reserved.
//

#import "BGImageTextField.h"


@implementation BGImageTextField

@synthesize buttonImage;
@synthesize alternateButtonImage;
@synthesize titleImage;

- (void)resetCursorRects {
	
	NSRect textFrame = NSInsetRect([self frame], 2, 2);
	textFrame.size.width -= 18;
	
	[self addCursorRect: [self calculateTextFrame: [self frame]] cursor: [NSCursor IBeamCursor]];
	
	[self addCursorRect: [self calculateButtonFrame] cursor: [NSCursor arrowCursor]];
}

- (void)updateTrackingAreas {
	
	[self removeTrackingArea: buttonTrackingArea];
	[buttonTrackingArea release];
	
	buttonTrackingArea = [[NSTrackingArea alloc] initWithRect: [self calculateButtonFrame] options: NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp owner: self userInfo: nil];
}

- (void)mouseDown:(NSEvent *)theEvent {
    
	NSPoint point = [self convertPoint: [theEvent locationInWindow] fromView: nil];
	
	if([self mouse: point inRect: [self calculateButtonFrame]]) {

		mouseDown = YES;
		[self setNeedsDisplay: YES];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
    
	NSPoint point = [self convertPoint: [theEvent locationInWindow] fromView: nil];
	
	if([self mouse: point inRect: [self calculateButtonFrame]]) {

		mouseDown = NO;
		[self setNeedsDisplay: YES];
		
		[NSApp sendAction: [self buttonAction] to: [self buttonTarget] from: self];
	}	
}

-(void)drawRect:(NSRect) rect {

	[super drawRect: rect];
	
	if(![[self titleImage] isEqualToString: @""] && [self titleImage] != nil) {
		
		NSImage *title = [self resizeImage: [NSImage imageNamed: [self titleImage]]];
		[title setFlipped: YES];
		[title drawInRect: [self calculateImageFrame] fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: 1.0];
	}
	
	NSImage *button;
	
	if(mouseDown == YES) {
		
		button = [self resizeImage: [NSImage imageNamed: [self alternateButtonImage]]];
	} else {
		
		button = [self resizeImage: [NSImage imageNamed: [self buttonImage]]];
	}
	
	[button setFlipped: YES];
	[button drawInRect: [self calculateButtonFrame] fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: 1.0];
}

-(SEL)buttonAction {
	
	return myAction;
}

-(void)setButtonAction:(SEL) newAction {
	
	myAction = newAction;
}

-(id)buttonTarget {
	
	return myTarget;
}

-(void)setButtonTarget:(id) newTarget {
	
	myTarget = newTarget;
}

-(NSRect)calculateButtonFrame {
	
	NSRect result;
	
	if(![[self buttonImage] isEqualToString: @""] && [self buttonImage] != nil) {

		NSImage *image = [self resizeImage: [NSImage imageNamed: [self buttonImage]]];
		
		result = NSMakeRect(([self frame].size.width - [image size].width) -4, ([self frame].size.height /2) - ([image size].height /2), [image size].width, [image size].height);

	} else {
		
		result = NSMakeRect(0, 0, 0, 0);
	}
	
	return result;
}

-(NSRect)calculateImageFrame {
	
	NSRect result;
	
	if(![[self titleImage] isEqualToString: @""] && [self titleImage] != nil) {
		
		NSImage *image = [self resizeImage: [NSImage imageNamed: [self titleImage]]];
		
		result = NSMakeRect(4, ([self frame].size.height /2) - ([image size].height /2), 
							[image size].width, [image size].height);

	} else {
		
		result = NSMakeRect(0, 0, 0, 0);
	}
	
	return result;
}

-(NSRect)calculateTextFrame:(NSRect) rect {
	
	NSRect buttonFrame = [self calculateButtonFrame];
	NSRect imageFrame = [self calculateImageFrame];
	
	if(buttonFrame.size.width > 0) { buttonFrame.size.width += 6; }
	if(imageFrame.size.width > 0) { imageFrame.size.width += 4; }
	
	return NSMakeRect(rect.origin.x + imageFrame.size.width, rect.origin.y,
					  rect.size.width - (buttonFrame.size.width + imageFrame.size.width), rect.size.height);
}

-(NSImage *)resizeImage:(NSImage *) sourceImage {

	if([sourceImage size].height > [self frame].size.height - 8) {
		
		//Resize our image
		float resizeRatio = ([self frame].size.height - 8) / [sourceImage size].height;
		
		[sourceImage setScalesWhenResized: YES];
		[sourceImage setSize: NSMakeSize([sourceImage size].width * resizeRatio, [self frame].size.height - 8)];
	}
	
	return [[sourceImage copy] autorelease];
}

@end
