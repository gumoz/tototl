//
//  AppController.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "AppController.h"

@implementation AppController

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
	
}
-(IBAction)show:(id)sender{
	[[ixayaTwitterController window] makeKeyAndOrderFront:self];
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
