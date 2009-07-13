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

@implementation AppDelegate

@synthesize accounts;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self readAccountsFromDefaults];
	}
	return self;
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
- (Class)accountFromKind:(NSString *)kind{
	
	Class accountClass;
	if([kind isEqualToString:@"twitter"])
		accountClass = [IXTwitterAccount class];
	return accountClass;
}

- (IBAction)openPreferences:(id)sender{	
	[[IXPreferencesController sharedController] showWindow:sender];
}

-(void)readAccountsFromDefaults{
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults] arrayForKey:@"accounts"];
	NSLog(@"accounts: %@", defaultsAccounts);
	NSMutableArray *tmpArray = [NSMutableArray new];
	
	for(NSDictionary *accountDictionary in defaultsAccounts)
	{
		IXTwitterAccount *account = nil;
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

@end
