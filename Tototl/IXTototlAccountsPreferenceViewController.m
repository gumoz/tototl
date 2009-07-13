//
//  IXTototlAccountsPreferenceViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlAccountsPreferenceViewController.h"


@implementation IXTototlAccountsPreferenceViewController

@synthesize accounts, kinds;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"IXTototlAccountsPreferenceView" bundle:nil];
		
//		NSDictionary *twitterKindDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//											   @"name", @"twitter", 
//											   @"picture", [NSImage imageNamed:@"twitter_logo_32"], nil];
//		
//		NSDictionary *facebookKindDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//												@"name", @"facebook", 
//												@"picture", [NSImage imageNamed:@"twitter_logo_32"], nil];
//
//		self.kinds = [NSArray arrayWithObjects:twitterKindDictionary, facebookKindDictionary, nil];
		
	}
	return self;
}

-(void)saveAccounts{
	NSMutableArray *mutableAccounts = [NSMutableArray new];
	
	for(IXTototlAccount *account in accounts)
	{
		if(account.username != nil && [account.username class] != [NSNull class])
		{
			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"username", account.saveInKeychain, @"saveInKeychain", account.kind, @"kind", account.enabled, @"enabled", nil];
			[mutableAccounts addObject:dict];
			[account savePasswordInKeychain];
		}
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"mutable accounts: %@", mutableAccounts);
	[defaults setObject:[NSArray arrayWithArray:mutableAccounts] forKey:@"accounts"];
	[defaults synchronize];
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
	[self readAccountsFromDefaults];
}
-(void)willStopDisplaying{
	NSLog(@"willStopDisplaying");
	[self saveAccounts];
}
-(void)readAccountsFromDefaults{
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults] arrayForKey:@"accounts"];
	NSLog(@"accounts: %@", defaultsAccounts);
	NSMutableArray *tmpArray = [NSMutableArray new];
	
	for(NSDictionary *accountDictionary in defaultsAccounts)
	{
		IXTototlAccount *account = nil;
		NSString *kind = nil;
		kind = [accountDictionary valueForKey:@"kind"];
		if(kind != nil)
		{
			account = [[self accountFromKind:kind] new];
			account.kind = kind;
			account.username = [accountDictionary valueForKey:@"username"];
			account.saveInKeychain = [accountDictionary valueForKey:@"saveInKeychain"];
			account.enabled = [accountDictionary valueForKey:@"enabled"];
			[account retrievePasswordFromKeychain];
			[tmpArray addObject:account];			
		} else {
			NSLog(@"unknown");
		}
	}
	
	[self setAccounts:[NSArray arrayWithArray:tmpArray]];
	NSLog(@"defaultsAccounts: %@", defaultsAccounts);
	NSLog(@"tmpArray: %@", tmpArray);
}
- (Class)accountFromKind:(NSString *)kind {
	
	Class accountClass;
	if([kind isEqualToString:@"twitter"])
		accountClass = 	NSClassFromString(@"IXTwitterAccount");
	
	return accountClass;
}
@end
