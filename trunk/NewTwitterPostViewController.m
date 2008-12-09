//
//  NewTwitterPostWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 28/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "NewTwitterPostViewController.h"


@implementation NewTwitterPostViewController

@synthesize delegate, twitterEngine, growlController;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"NewTwitterPostView" bundle:nil];
		growlController = [[NSApp delegate] performSelector:@selector(growlController)];
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
	NSString *msj = [message stringValue];
	if([msj length] > 140)
	{
		NSImage *t = [NSImage imageNamed:@"t"];
		[growlController growl:@"Unable to post to twitter, message is longer than 140 Chars" withTitle:@"Post Error" andIcon:[t TIFFRepresentation]];
	} else {
		[twitterEngine sendUpdate:msj];	
		[delegate performSelector:@selector(dettachTwitterPost)];	
	}
}

@end
