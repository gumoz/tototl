//
//  AppController.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "AppController.h"

@implementation AppController
- (id) init
{
	self = [super init];
	if (self != nil) {
		shown = NO;
	}
	return self;
}

-(void)awakeFromNib{
	ixayaTwitterController = [[IxayaTwitterWindowController alloc] init];
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setTitle:@"Tototl"];
	[statusItem setImage:[NSImage imageNamed:@"away.png"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:barMenu];
	[statusItem setEnabled:YES];
	[ixayaTwitterController setStatusItem:statusItem];
	[self show:self];
	[ixayaTwitterController performSelector:@selector(connect:) withObject:self];
	
	[statusItem setAction:@selector(statusClicked)];
	
}
-(void)statusClicked{

	NSLog(@"clicked %d", shown);
	if(shown)
	{
		[self hide:self];
		shown = NO;
	}
	else
	{
		[self show:self];
		shown = YES;		
	}
}
-(IBAction)showOrHide:(id)sender{

	NSWindow *window = [ixayaTwitterController window];
	if([window isKeyWindow])
	{
		[window orderOut:self];	
	}
	else{
		[window makeKeyAndOrderFront:self];
		[window orderFrontRegardless];

	}
	
//	[self statusClicked];
}
-(IBAction)show:(id)sender{
	[[ixayaTwitterController window] makeKeyAndOrderFront:self];
	[[ixayaTwitterController window] orderFrontRegardless];
}
-(IBAction)hide:(id)sender{
	NSWindow *window = [ixayaTwitterController window];
	[window orderOut:self];
}
-(IBAction)close:(id)sender{
	[[ixayaTwitterController window] close];
	[NSApp terminate:self];
}
- (int)tag{
	return 0;
}
@end
