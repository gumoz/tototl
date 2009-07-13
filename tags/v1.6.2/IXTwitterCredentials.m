//
//  IXTwitterCredentials.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXTwitterCredentials.h"

@implementation IXTwitterCredentials
@synthesize username, password;
- (id) init
{
	self = [super init];
	if (self != nil) {
		NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
		username = [defaults valueForKey:@"username"];
		password = @"";
		[[EMKeychainProxy sharedProxy] setLogsErrors:YES];
		[self read];
	}
	return self;
}
- (void)read{
	
	if(keychainItem == nil)
	{
		keychainItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tototl" withUsername:username];
		if(keychainItem == nil)
			[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Tototl" withUsername:username password:password];			
		
	} else {
		//	NSString *username = [keychainItem username];
		NSString *aPassword = [keychainItem password];

		NSLog(@"aPassword %@", aPassword);
		if(aPassword != nil)
		{
			NSLog(@"a password is not nil");
			[self setPassword:aPassword];
		}
	}
}
- (void)save{
	
	if(keychainItem == nil)
	{
		[[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Tototl" withUsername:username password:password];	
	}
	//Change the user and password
	[keychainItem setUsername:username];
	[keychainItem setPassword:password];
	
	
//	EMInternetKeychainItem *keychainItem = [[EMKeychainProxy sharedProxy] internetKeychainItemForServer:@"apple.com" withUsername:@"sjobs" path:@"/httpdocs" port:21 protocol:kSecProtocolTypeFTP];
	
}
- (void)synchronize{
	keychainItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tototl" withUsername:username];
	
	NSString *keychainUsername = [keychainItem username];
	NSString *keychainPassword = [keychainItem password];
	
	// we check if the username is equal
	if([keychainUsername isEqualToString:username] == NO)
	{
		[keychainItem setUsername:username];
		NSLog(@"username is not equal %@", username);
	}
	
	// we check if the password is equal
	if([keychainPassword isEqualToString:password] == NO)
	{
		[keychainItem setPassword:password];
		NSLog(@"password is not equal %@", password);
	}
	
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	[defaults setObject:username forKey:@"username"];
	[defaults setObject:password forKey:@""];
	[defaults synchronize];	
}
- (IBAction)save:(id)sender{
//	[self save];
	[self synchronize];	
}
- (IBAction)synchronize:(id)sender{
	[self synchronize];	
}
@end
