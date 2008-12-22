//
//  NewTwitterPostWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 28/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "NewTwitterPostViewController.h"


@implementation NewTwitterPostViewController

@synthesize delegate, twitterEngine, growlController, connected, message, messageCount;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"NewTwitterPostView" bundle:nil];
		growlController = [[NSApp delegate] performSelector:@selector(growlController)];
		message = @"";
		messageCount = [NSNumber numberWithInt:0];
		messageCountFontColor = [NSColor whiteColor];
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
	NSString *msj = [messageField stringValue];
	if([msj length] > 140)
	{
		NSImage *t = [NSImage imageNamed:@"t"];
		[growlController growl:@"Unable to post to twitter, message is longer than 140 Chars" withTitle:@"Post Error" andIcon:[t TIFFRepresentation]];
	} else {
		[twitterEngine sendUpdate:msj];
		
		BOOL soundEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"sentMessageSound"];
		if(soundEnabled)
		{
			NSSound *sound = [NSSound soundNamed:@"SentMessage"];
			[sound play];
		}
		[delegate performSelector:@selector(dettachTwitterPost)];	
	}
}
-(IBAction)messageCount:(id)sender{
	[self countMessageLenght];
}
-(void)didChangeValueForKey:(NSString *)key{
	if([key isEqualToString:@"message"])
		[self countMessageLenght];

	[super didChangeValueForKey:key];
}
-(void)countMessageLenght{
	int length = [[messageField stringValue] length];
	if(length > 140)
		messageCountFontColor = [NSColor redColor];
	else
		messageCountFontColor = [NSColor whiteColor];

	[self setValue:[NSNumber numberWithInt:length] forKey:@"messageCount"];

	// fixme binding
	[messageCountField setTextColor:messageCountFontColor];

	
	
}
@end
