//
//  TototlStatusItem.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 12/1/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "TototlStatusItemView.h"
#import "AppController.h"


@implementation TototlStatusItemView

- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (id)initWithFrame:(NSRect)frame controller:(AppController *)ctrlr
{
    if (self = [super initWithFrame:frame]) {
        controller = ctrlr; // deliberately weak reference.
		[self setMenu:[ctrlr barMenu]];
    }
    
    return self;
}


- (void)dealloc
{
    controller = nil;
    [super dealloc];
}


- (void)drawRect:(NSRect)rect {
    // Draw background if appropriate.
    if (clicked) {
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(rect);
    }
    
    // Draw some text, just to show how it's done.
    NSString *text = @"T"; // whatever you want
    
    NSColor *textColor = [NSColor controlTextColor];
    if (clicked) {
        textColor = [NSColor selectedMenuItemTextColor];
    }
	[NSImage imageNamed:@"away.png"];
	//
//	[statusItem setTitle:@"T"];
//	[statusItem setImage:[NSImage imageNamed:@"away.png"]];
//	[statusItem setHighlightMode:YES];
//	//	[statusItem setMenu:barMenu];
//	[statusItem setEnabled:YES];

	
    NSFont *msgFont = [NSFont menuBarFontOfSize:15.0];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSCenterTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     msgFont, NSFontAttributeName,
                                     textColor, NSForegroundColorAttributeName,
                                     paraStyle, NSParagraphStyleAttributeName,
                                     nil];
    [paraStyle release];
    
    NSSize msgSize = [text sizeWithAttributes:msgAttrs];
    NSRect msgRect = NSMakeRect(0, 0, msgSize.width, msgSize.height);
    msgRect.origin.x = ([self frame].size.width - msgSize.width) / 2.0;
    msgRect.origin.y = ([self frame].size.height - msgSize.height) / 2.0;
    
    [text drawInRect:msgRect withAttributes:msgAttrs];
}
- (void)mouseDown:(NSEvent *)event
{
	if ([event clickCount] > 1) {
		[self handleDoubleClick:event];
	} else {
		[self handleSingleClick:event];
	}
}
- (void) handleSingleClick:(NSEvent *) inEvent
{
	// do single click stuff
	NSRect frame = [[self window] frame];
	NSPoint point = NSMakePoint(NSMidX(frame), NSMinY(frame));
	[controller toggleNewTwitterPost:point];
	clicked = !clicked;
	[self setNeedsDisplay:YES];		
}

- (void) handleDoubleClick:(NSEvent *) inEvent
{	
	// do double click stuff
	[controller show:self];
}

@end