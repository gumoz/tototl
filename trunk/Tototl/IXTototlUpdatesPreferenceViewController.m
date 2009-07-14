//
//  IXTototlUpdatesPreferenceViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlUpdatesPreferenceViewController.h"


@implementation IXTototlUpdatesPreferenceViewController
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"IXTototlUpdatesPreferenceView" bundle:nil];	
	}
	return self;
}
#pragma mark Toolbar
- (NSString *)title
{
	return NSLocalizedString(@"Updates", @"Title of 'Updates' preference pane");
}

- (NSString *)identifier
{
	return @"UpdatesPane";
}

- (NSImage *)image
{
	return [NSImage imageNamed:@"SoftwareUpdate"];
}
//-(void)willBeDisplayed{
//}
//-(void)willStopDisplaying{
//}	
@end
