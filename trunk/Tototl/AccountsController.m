//
//  AccountsController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "AccountsController.h"


@implementation AccountsController

@synthesize accounts;

- (void)dealloc
{
	self.accounts = nil;
	[super dealloc];
}

static AccountsController *sharedAccountsController = nil;

+ (AccountsController *)sharedController
{
	@synchronized(self) {
		if (sharedAccountsController == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedAccountsController;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedAccountsController == nil) {
			sharedAccountsController = [super allocWithZone:zone];
			return sharedAccountsController;
		}
	}
	return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return UINT_MAX; // denotes an object that cannot be released
}

- (void)release
{
	// do nothing
}

- (id)autorelease
{
	return self;
}

-(void)saveAccounts {
	NSMutableArray *mutableAccounts = [NSMutableArray new];
	
	for(IXTototlAccount *account in accounts)
	{
		if(account.username != nil && [account.username class] != [NSNull class])
		{
			[mutableAccounts addObject:[account defaultsDictionary]];
			NSLog(@"dict: %@ ", [account defaultsDictionary]);
			[account savePasswordInKeychain];
		}
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"mutable accounts: %@", mutableAccounts);
	[defaults setObject:[NSArray arrayWithArray:mutableAccounts] forKey:@"accounts"];
	[defaults synchronize];
}
-(void)readAccountsFromDefaults{
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults] arrayForKey:@"accounts"];
	NSMutableArray *tmpArray = [NSMutableArray new];
	
	for(NSDictionary *accountDictionary in defaultsAccounts)
	{
		IXTototlAccount *account = nil;
		NSString *kind = nil;
		kind = [accountDictionary valueForKey:@"kind"];
		if(kind != nil)
		{
			account = [[self accountFromKind:kind] new];
			[account readDefaultsFromDictionary:accountDictionary];
			[tmpArray addObject:account];			
		} else {
			NSLog(@"unknown");
		}
	}
	
	[self setAccounts:[NSArray arrayWithArray:tmpArray]];
	NSLog(@"defaultsAccounts: %@", defaultsAccounts);
}
- (Class)accountFromKind:(NSString *)kind {
	
	Class accountClass;
	if([kind isEqualToString:@"twitter"])
		accountClass = 	NSClassFromString(@"IXTwitterAccount");
	
	return accountClass;
}
-(NSMutableArray *)accounts {
    if (!accounts) {
        [self readAccountsFromDefaults];
    }
    return [[accounts retain] autorelease];
	
}
@end
