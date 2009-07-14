//
//  IXPreferencesController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXPreferencesController.h"
#import "IXTototlAccountsPreferenceViewController.h"
#import "IXTototlConfigurationPreferenceViewController.h"
#import "IXTototlUpdatesPreferenceViewController.h"
#import "IXTototlFeedbackPreferenceViewController.h"

@implementation IXPreferencesController

- (void)showWindow:(id)sender
{
	IXTototlAccountsPreferenceViewController *tototlAccounts = [IXTototlAccountsPreferenceViewController new];
	IXTototlConfigurationPreferenceViewController *tototlConfiguration = [IXTototlConfigurationPreferenceViewController new];
	IXTototlUpdatesPreferenceViewController *tototlUpdates = [IXTototlUpdatesPreferenceViewController new];	
	IXTototlFeedbackPreferenceViewController *tototlFeedback = [IXTototlFeedbackPreferenceViewController new];		
	
	[[IXPreferencesController sharedController] setModules:[NSArray arrayWithObjects:tototlAccounts, tototlConfiguration, tototlUpdates, tototlFeedback, nil]];
	[tototlAccounts release];
	[tototlConfiguration release];
	[super showWindow:sender];
}
- (void)windowWillClose:(NSNotification *)notification{
	NSLog(@"window will close");
	if ([(NSObject *)_currentModule respondsToSelector:@selector(willStopDisplaying)]) {
		[_currentModule willStopDisplaying];
	}
}
@end
