//
//  PreferencesWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/22/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "IXTototlAccount.h"

@implementation PreferencesWindowController

@synthesize accounts;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithWindowNibName:@"Preferences"];
	}
	return self;
}

- (void)windowWillClose:(NSNotification *)notification{
	NSLog(@"window will close");
	[self saveAccounts];
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
	[defaults setObject:[NSArray arrayWithArray:mutableAccounts] forKey:@"accounts"];
	[defaults synchronize];
	
	
}
@end
