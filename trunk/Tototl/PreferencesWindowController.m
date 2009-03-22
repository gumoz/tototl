//
//  PreferencesWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/22/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "PreferencesWindowController.h"


@implementation PreferencesWindowController

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithWindowNibName:@"Preferences"];
	}
	return self;
}

@end
