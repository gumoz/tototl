//
//  IXPreferencesController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXPreferencesController.h"
#import "IXTototlAccountsPreferenceViewController.h"

@implementation IXPreferencesController

- (void)showWindow:(id)sender
{
	IXTototlAccountsPreferenceViewController *tototlAccounts = [IXTototlAccountsPreferenceViewController new];
	[[IXPreferencesController sharedController] setModules:[NSArray arrayWithObjects:tototlAccounts, nil]];
	[tototlAccounts release];
	[super showWindow:sender];
}
- (void)windowWillClose:(NSNotification *)notification{
	NSLog(@"window will close");
	if ([(NSObject *)_currentModule respondsToSelector:@selector(willBeDisplayed)]) {
		[_currentModule willStopDisplaying];
	}
}
@end
