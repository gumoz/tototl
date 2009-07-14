//
//  IXTototlEditAccountWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlEditAccountWindowController.h"


@implementation IXTototlEditAccountWindowController

@synthesize account;

+ (void)sheetWithAccount:(IXTototlAccount *)account forWindow:(NSWindow *)window{
	IXTototlEditAccountWindowController	*windowController = [[IXTototlEditAccountWindowController alloc] init];
	[windowController setAccount:account];
	[windowController beginSheetUsingWindow:window];
	[windowController release];
}
-(IBAction)close:(id)sender{
	[self endSheet];
}

-(void)beginSheetUsingWindow:(NSWindow *)delegateWindow
{
	if(delegateWindow != nil)
	{
		[NSApp beginSheet:[self window]
		   modalForWindow:delegateWindow
			modalDelegate:self
		   didEndSelector:nil
			  contextInfo:nil];
	}
}
-(void)endSheet
{
		[[self window] close];
		[NSApp endSheet:[self window]];
}
@end
