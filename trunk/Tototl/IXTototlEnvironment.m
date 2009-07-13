//
//  IXTototlEnvironment.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlEnvironment.h"


@implementation IXTototlEnvironment

@synthesize preferencesToolbarConfiguration;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self load];
	}
	return self;
}
-(void)load {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.preferencesToolbarConfiguration = [defaults objectForKey:@"preferencesToolbarConfiguration"];
}
@end
