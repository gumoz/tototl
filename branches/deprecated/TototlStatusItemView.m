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

enum {
	NormalStatus = 0,
	MessageStatus = 1,
	DirectMessageStatus = 2
};

- (id) init
{
	self = [super init];
	if (self != nil) {
		kind = NormalStatus;
		numberToShow = 0;
		badge = [[CTBadge alloc] init];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frame controller:(AppController *)ctrlr
{
    if (self = [super initWithFrame:frame]) {
        controller = ctrlr; // deliberately weak reference.
		[self setMenu:[ctrlr barMenu]];
		kind = NormalStatus;
		numberToShow = 0;
		badge = [[CTBadge alloc] init];
    }
    return self;
}


- (void)dealloc
{
    controller = nil;
    [super dealloc];
}
- (void)drawRect:(NSRect)rect {

	NSImage *image = nil;
	switch (kind) {
		case NormalStatus:
			image = [NSImage imageNamed:@"NormalStatus24.png"];
			break;
		case MessageStatus:
			image = [NSImage imageNamed:@"NewMessage24.png"];
			break;
		case DirectMessageStatus:
			image = [NSImage imageNamed:@"DirectMessageMessage24.png"];
			break;
		default:
			image = [NSImage imageNamed:@"NormalStatus24.png"];
	}
	if(numberToShow > 0)
	{
		NSImage *badgeOverlay = [badge badgeOverlayImageForValue:numberToShow insetX:0 y:0 ofSize:24 andBadgeSize:14];
		[badgeOverlay lockFocus]; // we lockfocus in order to retain the background image;
		[image compositeToPoint:NSZeroPoint operation:NSCompositeDestinationOver];
		[badgeOverlay unlockFocus];
		[badgeOverlay drawInRect:rect fromRect:rect operation:NSCompositeCopy fraction:1.0];
		
	} else {
		[image drawInRect:rect fromRect:rect operation:NSCompositeCopy fraction:1.0];
	}
	
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

//	BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"SingleClickOpenWindow"];
//	// not executed if menu
//	if (show)
//	{
//		kind = NormalStatus;
//		[controller showOrHide:self];
//	} else {
//		// do single click stuff
//		NSRect frame = [[self window] frame];
//		NSPoint point = NSMakePoint(NSMidX(frame), NSMinY(frame));
//		[controller toggleNewTwitterPost:point];
//		clicked = !clicked;
//	}
	clicked = !clicked;
	kind = NormalStatus;
	numberToShow = 0;
	[controller singleClick];
	[self setNeedsDisplay:YES];
}

- (void) handleDoubleClick:(NSEvent *) inEvent
{	
	// do double click stuff
	[controller doubleClick];
	kind = NormalStatus;
	numberToShow = 0;
	[self setNeedsDisplay:YES];
}
- (void)gotMessages:(int)amount{
	kind = MessageStatus;
	NSLog(@"gotMessages %d", amount);
	numberToShow += amount;
	[self setNeedsDisplay:YES];
}
- (void)gotDirectMessages:(int)amount{
	kind = DirectMessageStatus;	
	NSLog(@"gotDirectMessages %d", amount);
	numberToShow += amount;
	[self setNeedsDisplay:YES];
}


// Draw background if appropriate.
//if (clicked) {
//	[[NSColor selectedMenuItemColor] set];
//	NSRectFill(rect);
//}

// Draw some text, just to show how it's done.
//    NSString *text = @"T"; // whatever you want

//NSColor *textColor = [NSColor controlTextColor];
//if (clicked) {
//	textColor = [NSColor selectedMenuItemTextColor];
//}

//
//	[statusItem setTitle:@"T"];
//	[statusItem setImage:[NSImage imageNamed:@"away.png"]];
//	[statusItem setHighlightMode:YES];
//	//	[statusItem setMenu:barMenu];
//	[statusItem setEnabled:YES];


//    NSFont *msgFont = [NSFont menuBarFontOfSize:15.0];
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
//    [paraStyle setAlignment:NSCenterTextAlignment];
//    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//	
//    NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     msgFont, NSFontAttributeName,
//                                     textColor, NSForegroundColorAttributeName,
//                                     paraStyle, NSParagraphStyleAttributeName,
//                                     nil];
//    [paraStyle release];
//    
//    NSSize msgSize = [text sizeWithAttributes:msgAttrs];
//    NSRect msgRect = NSMakeRect(0, 0, msgSize.width, msgSize.height);
//    msgRect.origin.x = ([self frame].size.width - msgSize.width) / 2.0;
//    msgRect.origin.y = ([self frame].size.height - msgSize.height) / 2.0;
// [text drawInRect:msgRect withAttributes:msgAttrs];

@end