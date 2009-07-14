//
//  IXTototlFeedbackPreferenceViewController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTototlFeedbackPreferenceViewController.h"


@implementation IXTototlFeedbackPreferenceViewController
- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"IXTototlFeedbackPreferenceView" bundle:nil];	
	}
	return self;
}
#pragma mark Toolbar
- (NSString *)title
{
	return NSLocalizedString(@"Feedback", @"Title of 'Feedback' preference pane");
}

- (NSString *)identifier
{
	return @"FeedbackPane";
}

- (NSImage *)image
{
	return [NSImage imageNamed:@"Feedback"];
}
//-(void)willBeDisplayed{
//}
//-(void)willStopDisplaying{
//}	
@end
