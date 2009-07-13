//
//  IXEditAccountWindow.m
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
	
	[NSApp beginSheet:[windowController window]
	   modalForWindow:window
		modalDelegate:windowController
	   didEndSelector:nil
		  contextInfo:nil];
	
	[windowController release];
}
-(IBAction)close:(id)sender{
	
}
@end
