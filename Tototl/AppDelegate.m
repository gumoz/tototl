//
//  AppDelegate.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "AppDelegate.h"
#import "IXTwitterAccount.h"
#import "PreferencesWindowController.h"

@implementation AppDelegate

@synthesize accounts;
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self readAccountsFromDefaults];
		[self openPreferences:self];
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
	PreferencesWindowController *preferences = [[PreferencesWindowController alloc] init];
	[preferences setAccounts:[NSMutableArray arrayWithArray:accounts]];
	[preferences showWindow:self];
}
-(void)readAccountsFromDefaults{
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults] arrayForKey:@"accounts"];
	
	NSMutableArray *tmpArray = [NSMutableArray new];
	for(NSDictionary *accountDictionary in defaultsAccounts)
	{
		IXTwitterAccount *account;
		NSString *kind = [accountDictionary valueForKey:@"kind"];
		account = [[self accountFromKind:kind] new];
		account.kind = kind;
		account.username = [accountDictionary valueForKey:@"username"];
		account.saveInKeychain = [accountDictionary valueForKey:@"saveInKeychain"];
		account.enabled = [accountDictionary valueForKey:@"enabled"];
		[account retrievePasswordFromKeychain];
		[tmpArray addObject:account];
	}
	[self setAccounts:[NSArray arrayWithArray:tmpArray]];
	NSLog(@"defaultsAccounts: %@", defaultsAccounts);
	NSLog(@"tmpArray: %@", tmpArray);
}


@end
