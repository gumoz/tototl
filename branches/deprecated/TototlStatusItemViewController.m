//
//  TototlStatusItemViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 12/1/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "TototlStatusItemViewController.h"
#import "AppController.h"

@implementation TototlStatusItemViewController
@synthesize statusItem, connection, controller;
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"TototlStatusItemView" bundle:nil];
		
		
//		float width = 30.0;
//		float height = [[NSStatusBar systemStatusBar] thickness];
//		NSRect viewFrame = NSMakeRect(0, 0, width, height);
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
		[statusItem setView:[self view]];		
	}
	return self;
}
- (void)mouseDown:(NSEvent *)event
{
    NSRect frame = [[[self view] window] frame];
    NSPoint point = NSMakePoint(NSMidX(frame), NSMinY(frame));
    [controller toggleNewTwitterPost:point];
    clicked = !clicked;
    [[self view] setNeedsDisplay:YES];
}

@end
