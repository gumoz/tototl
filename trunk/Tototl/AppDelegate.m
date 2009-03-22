//
//  AppDelegate.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"

@implementation AppDelegate
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self openPreferences:self];
		NSLog(@"open");
	}
	return self;
}

- (IBAction)openPreferences:(id)sender{
	PreferencesWindowController *preferences = [[PreferencesWindowController alloc] init];
	[preferences showWindow:self];
}

@end
