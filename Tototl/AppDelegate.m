//
//  AppDelegate.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "AppDelegate.h"
#import "IXTwitterAccount.h"
#import "IXPreferencesController.h"
#import "IXTwitterMessageWindowController.h"

@implementation AppDelegate

@synthesize accounts;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.accounts = [[AccountsController sharedController] accounts];
		[self openTwitterWindows];
		[self connectAll];
	}
	return self;
}
- (void)openTwitterWindows{

	for(IXTwitterAccount *account in accounts)
	{
		if([[account enabled] boolValue])
		{
			IXTwitterMessageWindowController *windowController = [IXTwitterMessageWindowController new];
			[windowController setAccount:account];
			[windowController showWindow:self];
		}
	}
}
- (void)connectAll{
	for(IXTototlAccount *account in accounts)
	{
		if([[account enabled] boolValue])
		{
			[account connect];
		}
	}
}
- (IBAction)openPreferences:(id)sender{	
	[[IXPreferencesController sharedController] showWindow:sender];
}
@end
