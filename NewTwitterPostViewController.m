//
//  NewTwitterPostWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 28/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "NewTwitterPostViewController.h"


@implementation NewTwitterPostViewController

@synthesize delegate, twitterEngine;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"NewTwitterPostView" bundle:nil];
	}
	return self;
}

-(void)awakeFromNib{
//	[[self window] makeFirstResponder:message];
}
-(IBAction)cancel:(id)sender{
	[delegate performSelector:@selector(dettachTwitterPost)];
	//	[self close];
}
-(IBAction)post:(id)sender{
	[twitterEngine sendUpdate:[message stringValue]];
	[delegate performSelector:@selector(dettachTwitterPost)];
}

@end
