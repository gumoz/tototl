//
//  IXTototlEditTwitterAccountWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlEditTwitterAccountWindowController.h"


@implementation IXTototlEditTwitterAccountWindowController

@synthesize deliveryMethods;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithWindowNibName:@"IXTototlEditTwitterAccountWindow"];
		deliveryMethods = [NSArray arrayWithObjects:@"im", @"sms", @"none", nil];
	}
	return self;
}
-(IBAction)setLocation:(id)sender{
	SEL locationSel = @selector(sendLocationToTwitter);
	if([account respondsToSelector:locationSel])
		[account performSelector:locationSel];
}
-(IBAction)clearsCookies:(id)sender{
	SEL clearsCookiesSel = @selector(clearsCookies);
	if([account respondsToSelector:clearsCookiesSel])
		[account performSelector:clearsCookiesSel];
}
@end
