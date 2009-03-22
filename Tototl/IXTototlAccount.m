//
//  IXTototlAccount.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlAccount.h"


@implementation IXTototlAccount

@synthesize username;
@synthesize password;
@synthesize saveInKeychain;
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setKind:@"twitter"];
	}
	return self;
}

- (EMGenericKeychainItem *)retrieveKeychainItem{

	// if save in keychain is enabled, then search for a keychain item, if it does not exist then create one
	if([saveInKeychain boolValue])
	{
		EMGenericKeychainItem *keychainItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tototl" withUsername:username];
		if(keychainItem == nil)
			[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Tototl" withUsername:username password:password];
	}
}
- (void)retrievePasswordFromKeychain{
	EMGenericKeychainItem *keychainItem = [self retrieveKeychainItem];
	[self setPassword:[keychainItem password]];
}
- (void)save{
	
	// search accounts in preferences
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *accounts = [defaults arrayForKey:@"accounts"];
	
	BOOL found = NO;
	for(NSDictionary *account in accounts)
	{
		NSString *accountUsername = [account valueForKey:@"username"];
		if([accountUsername isEqualToString:account])
			found = YES;
	}
	
	// if no accounts in preferences, add it.
	if(found == NO)
	{
		NSMutableArray *mutableAccounts = [NSMutableArray arrayWithArray:accounts];

		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", saveInKeychain, @"saveInKeychain", kind, @"kind"];
		[mutableAccounts addObject:dict];
		[defaults setObject:[NSArray arrayWithArray:mutableAccounts] forKey:@"accounts"];
	}
	
	// if save in keychain, save it.
	if([saveInKeychain boolValue])
	{
		EMGenericKeychainItem *keychainItem = [self retrieveKeychainItem];
		[keychainItem setPassword:password];
	}
}

@end
