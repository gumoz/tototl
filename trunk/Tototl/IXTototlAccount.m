//
//  IXTototlAccount.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlAccount.h"


@implementation IXTototlAccount

@synthesize kind;
@synthesize enabled;
@synthesize username;
@synthesize password;
@synthesize saveInKeychain;

@synthesize isConnected;
@synthesize kindPicture;
@synthesize statusPicture;
@synthesize status;

- (id) init
{
	self = [super init];
	if (self != nil) {
//		[self setUsername:@""];
		[self setEnabled:[NSNumber numberWithBool:NO]];
		[self setKind:@"twitter"];
		[self setSaveInKeychain:[NSNumber numberWithBool:NO]];
		[self setKindPicture:[NSImage imageNamed:@"twitter_logo_32"]];
		[self setStatusPicture:[NSImage imageNamed:@"away"]];
		[self setStatus:@"Disconected"];
	}
	return self;
}

- (EMGenericKeychainItem *)retrieveKeychainItem{

	// if save in keychain is enabled, then search for a keychain item, if it does not exist then create one
	if([saveInKeychain boolValue])
	{
		EMGenericKeychainItem *keychainItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tototl" withUsername:username];
		return keychainItem;
	}
	return nil;
}
- (void)retrievePasswordFromKeychain{
	EMGenericKeychainItem *keychainItem = [self retrieveKeychainItem];
	if(keychainItem != nil)
	{	
		[self setPassword:[keychainItem password]];
	}

}
-(void)savePasswordInKeychain{
	
	// if save in keychain, save it.
	if([saveInKeychain boolValue] && password != nil && [password class] != [NSNull class])
	{
		EMGenericKeychainItem *keychainItem = [self retrieveKeychainItem];
		if(keychainItem == nil)
		{	
			[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Tototl" withUsername:username password:password];
		} else {
			[keychainItem setPassword:password];
		}

	}	
}
- (void)save{
	
	if(username != nil && [username class] != [NSNull class])
	{
		// search accounts in preferences
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *accounts = [defaults arrayForKey:@"accounts"];

		BOOL found = NO;
		for(NSDictionary *account in accounts)
		{
			NSString *accountUsername = [account valueForKey:@"username"];
			if([accountUsername isEqualToString:username])
				found = YES;
		}

		// if no accounts in preferences, add it.
		if(found == NO)
		{
			NSLog(@"create account");
			NSMutableArray *mutableAccounts = [NSMutableArray arrayWithArray:accounts];

			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", saveInKeychain, @"saveInKeychain", kind, @"kind", enabled, @"enabled", nil];
			NSLog(@"dict %@", dict);
				
			NSLog(@"username: %@, saveInKeychain: %@, kind: %@", username, saveInKeychain, kind);
			[mutableAccounts addObject:dict];
			[defaults setObject:[NSArray arrayWithArray:mutableAccounts] forKey:@"accounts"];
			[defaults synchronize];
		}
		[self savePasswordInKeychain];
	}
}
-(void)connect{
	
}
@end