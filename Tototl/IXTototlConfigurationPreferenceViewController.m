//
//  IXTototlConfigurationPreferenceViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlConfigurationPreferenceViewController.h"


@implementation IXTototlConfigurationPreferenceViewController
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"IXTototlConfigurationPreferenceView" bundle:nil];	
	}
	return self;
}
#pragma mark Toolbar
- (NSString *)title
{
	return NSLocalizedString(@"Configuration", @"Title of 'Configuration' preference pane");
}

- (NSString *)identifier
{
	return @"ConfigurationPane";
}

- (NSImage *)image
{
	return [NSImage imageNamed:@"NSAdvanced"];
}
//-(void)willBeDisplayed{
//}
//-(void)willStopDisplaying{
//}	
@end
