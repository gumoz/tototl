//
//  IxayaTwitterWindowController.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IxayaTwitterWindowController.h"
#import "IXTwitterCredentials.h"
#import "IXTwitterMessage.h"
#import <AutoHyperlinks/AutoHyperlinks.h>


@implementation IxayaTwitterWindowController

enum 
{
	twitterMessage = 0,
	twitterDirectMessage = 1
};

@synthesize twitts, connected, statusItem, twitterEngine, growlController, newTweetMessage;

- (id) init
{
	self = [super init];
	if (self != nil) {

		@try {
			NSLog(@"IXTWC init");
			growlController = [[NSApp delegate] performSelector:@selector(growlController)];
			defaults = [[NSUserDefaults alloc] init];
			
			BOOL old =  [defaults boolForKey:@"oldInterface"];
			BOOL tiny =  [defaults boolForKey:@"tinyInterface"];
			NSLog(@"IXTWC defaults");
			if(old)
				[self initWithWindowNibName:@"IxayaTwitterWindowOld"];
			else
			{
				if(tiny)
					[self initWithWindowNibName:@"IxayaTwitterWindowTiny"];
				else
					[self initWithWindowNibName:@"IxayaTwitterWindow"];
			}
			NSLog(@"IXTWC twitts");
			twitts = [[NSArray alloc] init];
			NSLog(@"IXTWC Connected");
			connected = [NSNumber numberWithBool:NO];
			NSLog(@"IXTWC Launching");
			launching = YES;
		}
		@catch (NSException * e) {
			NSLog(@"initialization Exception %@", e);
		}
		@finally {
			NSLog(@"end initialization");
		}

	}
	return self;
}

-(void)awakeFromNib{
	@try {
		NSLog(@"IXTWC awakening (AFN)");
		[[[configurationButton menu] menuRepresentation] setHorizontalEdgePadding:0.0];
		NSLog(@"IXTWC AFN setting credentials");
		IXTwitterCredentials *cred = [IXTwitterCredentials new];
		[cred read];
				
		NSLog(@"IXTWC DoneMenu, add credentials object to object controller");
		[credentials addObject:cred];
		
	}
	@catch (NSException * e) {
		NSLog(@"awakeFromNib Exception %@", e);
	}
	@finally {
		NSLog(@"end awakening");
	}
}
-(IBAction)configuration:(id)sender{
//	[[NSApp delegate] performSelector:@selector(checkForUpdates:) withObject:self];

	PreferencesWindowController *pref = [[PreferencesWindowController alloc] init];
	[pref showWindow:self];
	//	[[configurationButton menu] menuWillOpen:[configurationButton menu]];
}
-(IBAction)close:(id)sender{
	[[NSApp delegate] performSelector:@selector(close:) withObject:self];
}
-(IBAction)connect:(id)sender{
	@try {
		NSLog(@"IXTWC connecting");
		// set credentials on engine
		IXTwitterCredentials *someCredentials = [credentials content];	
		id username = [someCredentials valueForKey:@"username"];
		NSLog(@"username %@", username);			
		id password = [someCredentials valueForKey:@"password"];
		NSLog(@"password %@", password);			
			if(username && password)
			{
				[twitterEngine setUsername:username password:password];		
			
				// Get updates from people the authenticated user follows.
				[twitterEngine getFollowedTimelineFor:username since:nil startingAtPage:0];
			//	[twitterEngine getDirectMessagesSince:[NSDate dateWithTimeIntervalSinceReferenceDate:1200] startingAtPage:0];
			
			NSNumber *updateInterval = [defaults objectForKey:@"updateSeconds"];
			NSString *location = [defaults objectForKey:@"location"];
			if(location)
				[twitterEngine setLocation:location];
			

			if(updateInterval == nil)
			{	
				updateInterval = [NSNumber numberWithInt:120];
				[defaults setValue:updateInterval forKey:@"updateSeconds"];
				[defaults synchronize];
			}
			
			[NSTimer scheduledTimerWithTimeInterval:[updateInterval intValue]
											 target:self 
										   selector:@selector(update)
										   userInfo:nil
											repeats:YES];
			
			NSLog(@"save username");
			[someCredentials synchronize];
		}
	}
	@catch (NSException * e) {
		NSLog(@"Exception %@", [e description]);
	}
	@finally {
		[self endSheet:sender];
	}
	
	// crash the application just for fun in fact we do this in order to test smart crash reports
	//	NSLog("");
	//	id wa = nil;
	//	[self setValue:nil forKey:nil];
	//	[[NSApp delegate] setValue:nil forKey:nil];
	//	self = nil;
	
}
-(IBAction)postTweet:(id)sender{
	if([connected boolValue]) 
	{
		NSString *message = [newTweetMessageField stringValue];
		NSLog(@"message %@", message);
		if([message length] > 140)
		{
			NSLog(@"longer");
			NSImage *t = [NSImage imageNamed:@"t"];
			[growlController growl:@"Unable to post to twitter, message is longer than 140 Chars" withTitle:@"Post Error" andIcon:[t TIFFRepresentation]];
		} else {
			NSLog(@"shorter");
			[twitterEngine sendUpdate:message];	
			[newTweetMessageField setStringValue:@""];
			[self endSheet:sender];

			BOOL soundEnabled = [defaults boolForKey:@"sentMessageSound"];
			if(soundEnabled)
			{
				NSSound *sound = [NSSound soundNamed:@"SentMessage"];
				[sound play];
			}
		}
	} else {
		[growlController growl:@"try connecting before posting" withTitle:@"Not Connected to Twitter"];
	}
}
#pragma mark IXSheetWindowController implementation
-(NSWindow *)windowForTag:(int)tag{
	NSLog(@"tag %d", tag);
		switch (tag) {
			case 0:
				return credentialsWindow;
				break;
			case 1:
				return twitWindow;
				break;
				
			default:
				break;
		}
	
	return nil;
}
#pragma mark MGTwitterEngineDelegate methods


- (void)requestSucceeded:(NSString *)requestIdentifier
{
    NSLog(@"Request succeeded (%@)", requestIdentifier);
	if([connected boolValue] == NO)
	{
		NSNumber *connectedNumber = [NSNumber numberWithBool:YES];
		[self setConnected:connectedNumber];
		[[NSApp delegate] setConnected:connectedNumber];
		[statusItem setImage:[NSImage imageNamed:@"available.png"]];
		[[self window] makeFirstResponder:newTweetMessageField];
	}
}


- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	if(([error code] == 401 || [error code] == 400) && [[error domain] isEqualToString:@"HTTP"])
		[self setConnected:[NSNumber numberWithBool:NO]];
	
    NSLog(@"Twitter request failed! (%@) Error: %@ (%@)", 
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier
{
	if([statuses count] > 0)
	{
		NSLog(@"Got statuses:\r%@", statuses);
		NSMutableArray *newTweets = [[NSMutableArray alloc] init];
		for(id status in statuses)
		{	
			NSLog(@"date %@",[NSDate date]);
			NSString *name = [status valueForKeyPath:@"user.name"];
			NSString *text = [status valueForKeyPath:@"text"];
			NSString *profile_image_url = [status valueForKeyPath:@"user.profile_image_url"];
			NSString *twitter_id = [status valueForKeyPath:@"id"];
			NSDate *created = [status valueForKeyPath:@"created_at"];
			NSString *screen_name = [status valueForKeyPath:@"user.screen_name"];
			IXTwitterMessage *message = [[IXTwitterMessage alloc] init];
			[message setKind:twitterMessage];
			[message setName:name];
			[message setMessage:text];
			[message setPictureUsingUrl:profile_image_url];
			[message setTwitterId:twitter_id];
			[message setDate:created];
			[message setScreenName:screen_name];
			[newTweets addObject:[message retain]];


			
			// we check if the software is not fetching messages because is launching, if not then we post notifications to Growl and send a custom sound
			if(!launching)
			{
				[growlController growl:text withTitle:name andIcon:[message picture_data]];

				BOOL soundEnabled = [defaults boolForKey:@"receivedMessageSound"];
				if(soundEnabled)
				{
					NSSound *sound = [NSSound soundNamed:@"ReceivedMessage"];
					[sound play];
				}
					
			}
		}
		
		if(launching)
			launching = NO;
		
		NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:newTweets];
		[tmpArray addObjectsFromArray:[self twitts]];

		[self setTwitts:[NSArray arrayWithArray:tmpArray]];
		[twittsArrayController setSelectionIndex:0];
//		NSLog(@"twitts %@", twitts);
	}
}

// need to be fixed
- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	if([messages count] > 0)
	{
		NSLog(@"Got direct messages:\r%@", messages);
		
		NSMutableArray *newTweets = [[NSMutableArray alloc] init];
		for(id status in messages)
		{	
			NSLog(@"date %@",[NSDate date]);
			NSString *name = [status valueForKeyPath:@"user.name"];
			NSString *text = [status valueForKeyPath:@"text"];
			NSString *profile_image_url = [status valueForKeyPath:@"user.profile_image_url"];
			NSString *twitter_id = [status valueForKeyPath:@"id"];
			NSDate *created = [status valueForKeyPath:@"created_at"];
			NSString *screen_name = [status valueForKeyPath:@"user.screen_name"];
			
			IXTwitterMessage *message = [[IXTwitterMessage alloc] init];
			[message setKind:twitterDirectMessage];
			[message setName:name];
			[message setMessage:text];
			[message setPictureUsingUrl:profile_image_url];
			[message setTwitterId:twitter_id];
			[message setDate:created];
			[message setScreenName:screen_name];
			[newTweets addObject:[message retain]];
			
			
			// we check if the software is not fetching messages because is launching, if not then we post notifications to Growl and send a custom sound
			if(!launching)
			{
				[growlController growl:text withTitle:name andIcon:[message picture_data] isSticky:YES];
				
				BOOL soundEnabled = [defaults boolForKey:@"receivedDirectMessageSound"];
				if(soundEnabled)
				{
					NSSound *sound = [NSSound soundNamed:@"ReceivedDirectMessage"];
					[sound play];
				}
				
			}
			
			
		}
		NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:newTweets];
		[tmpArray addObjectsFromArray:[self twitts]];
		
		[self setTwitts:[NSArray arrayWithArray:tmpArray]];
		NSLog(@"twitts %@", twitts);
	}
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
    NSLog(@"Got user info:\r%@", userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	NSLog(@"Got misc info:\r%@", miscInfo);
}


- (void)imageReceived:(NSImage *)image forRequest:(NSString *)identifier
{
    NSLog(@"Got an image: %@", image);
    
    // Save image to the Desktop.
	//    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", identifier] stringByExpandingTildeInPath];
	//    [[image TIFFRepresentation] writeToFile:path atomically:NO];
}
-(void)update{
	NSString *username = [[credentials content] username];
	NSLog(@"last twitt %@", [twitts objectAtIndex:0]);
	
//	[twitts 
	
	int updateid = [[[twitts objectAtIndex:0] twitterId] intValue];
//	[twitterEngine getFollowedTimelineFor:[[credentials content] username] since:nil startingAtPage:0];
	[twitterEngine getFollowedTimelineFor:username sinceID:updateid startingAtPage:0 count:10];
	[twitterEngine getDirectMessagesSinceID:updateid startingAtPage:0];
	
//	- (NSString *)getFollowedTimelineFor:(NSString *)username sinceID:(int)updateID startingAtPage:(int)pageNum count:(int)count;		// max 200

}


#pragma mark character counting

-(void)countMessageLenght{
	int length = [[newTweetMessageField stringValue] length];
	if(length > 140)
		messageCountFontColor = [NSColor redColor];
	else
		messageCountFontColor = [NSColor blackColor];
	
	
	[messageCountField setIntValue:length];
	[messageCountField setTextColor:messageCountFontColor];
}
-(void)didChangeValueForKey:(NSString *)key{
	if([key isEqualToString:@"newTweetMessage"])
		[self countMessageLenght];
	
	[super didChangeValueForKey:key];
}
-(IBAction)setResponseUsingButton:(id)sender{


	int tag = [sender tag];
	NSLog(@"sender %@, tag %d", sender, tag);
	
	// we check if the tag is equal to a magic number tag (yeah, very obscure technique) 
	if(tag == 1985)
	{


		NSString *screenName = [sender alternateTitle];
		
//		NSLog(@"screenName: %@", screenName);
		NSString *atName = [NSString stringWithFormat:@"@%@ ", screenName];
		int atNameLength = [atName length];
		int newTweetMessageLength = [newTweetMessage length];
		// we check where to put the message
		if(newTweetMessageLength > 0)
		{
			// we check if we have not put the screenname before
			if(newTweetMessageLength >= atNameLength)
			{
				NSString *ntmss = [newTweetMessage substringWithRange:NSMakeRange(0, atNameLength)];
				if([ntmss isEqualToString:atName])
				   return; // we return because we already have the screenName
			}
			
			[self setNewTweetMessage:[NSString stringWithFormat:@"%@%@", atName, newTweetMessage]];
		}
		else
			[self setNewTweetMessage:atName]; // the field is empty, so we fill it with the Name


//		[[newTweetMessageField selectedCell] setSelectedRange:NSMakeRange(0, 0)];

		
		//this are the correct methods but are not correctly implemented fixme
		//		id tv = [[self window] fieldEditor:NO forObject:newTweetMessageField];
//		[tv setSelectedRange:setSelectedRange:NSMakeRange(0, 0)];
		[[self window] makeFirstResponder:newTweetMessageField];
	}
}
@end
