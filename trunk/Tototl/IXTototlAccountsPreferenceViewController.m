//
//  IXTototlAccountsPreferenceViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlAccountsPreferenceViewController.h"
#import "IXTototlEditTwitterAccountWindowController.h"

@implementation IXTototlAccountsPreferenceViewController

@synthesize accounts;
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"IXTototlAccountsPreferenceView" bundle:nil];
	}
	return self;
}
- (IBAction)editSelectedAccount:(id)sender{
	IXTototlAccount *selectedAccount = nil;
	selectedAccount = [accountsArrayController selection];
	NSLog(@"selected account: %@", selectedAccount);
	IXTototlEditTwitterAccountWindowController *controller = [IXTototlEditTwitterAccountWindowController new];
	[controller setAccount:selectedAccount];
	[controller beginSheetUsingWindow:[[self view] window]];
}
#pragma mark Toolbar
- (NSString *)title
{
	return NSLocalizedString(@"Accounts", @"Title of 'Accounts' preference pane");
}

- (NSString *)identifier
{
	return @"AccountsPane";
}
- (NSImage *)image
{
	return [NSImage imageNamed:@"NSUser"];
}
-(void)willBeDisplayed{
	self.accounts = [[IXTototlAccountsController sharedController] accounts];
}
-(void)willStopDisplaying{
	NSLog(@"willStopDisplaying");
	[[IXTototlAccountsController sharedController] saveAccounts:self.accounts];
}
- (IBAction)add:(id)sender {
	IXTototlAccount *account = [NSClassFromString(@"IXTwitterAccount") new];
	[accounts addObject:account];
	self.accounts = accounts;
}
@end
