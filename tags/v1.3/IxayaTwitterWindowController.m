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

@synthesize twitts, connected, statusItem, twitterEngine, growlController;

- (id) init
{
	self = [super init];
	if (self != nil) {

		growlController = [[NSApp delegate] performSelector:@selector(growlController)];
		defaults = [[NSUserDefaults alloc] init];
		BOOL old =  [defaults boolForKey:@"oldInterface"];
		if(old)
			[self initWithWindowNibName:@"IxayaTwitterWindowOld"];
		else
			[self initWithWindowNibName:@"IxayaTwitterWindow"];
		twitts = [[NSArray alloc] init];
		connected = [NSNumber numberWithBool:NO];
		launching = YES;
	}
	return self;
}

-(void)awakeFromNib{

	
	[[[configurationButton menu] menuRepresentation] setHorizontalEdgePadding:0.0];
	
	
	IXTwitterCredentials *cred = [IXTwitterCredentials new];
	defaults = [[NSUserDefaults alloc] init];
	[cred setValue:[defaults valueForKey:@"username"] forKey:@"username"];
	[cred setValue:[defaults valueForKey:@"password"] forKey:@"password"];
	[credentials addObject:cred];
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
	
	// set credentials on engine
	id someCredentials = [credentials content];	
    [twitterEngine setUsername:[someCredentials username] password:[someCredentials password]];
    
    // Get updates from people the authenticated user follows.
    [twitterEngine getFollowedTimelineFor:[someCredentials username] since:nil startingAtPage:0];
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
	
	[defaults setValue:[someCredentials username] forKey:@"username"];
	[defaults setValue:[someCredentials password] forKey:@"password"];
	[defaults synchronize];

//	[twitterEngine setLocation:@"Tototl"];
	
	[self endSheet:sender];
}
-(IBAction)postTweet:(id)sender{
	NSString *message = [newTweetMessage stringValue];
	NSLog(@"message %@", message);
	if([message length] > 140)
	{
		NSLog(@"longer");
		NSImage *t = [NSImage imageNamed:@"t"];
		[growlController growl:@"Unable to post to twitter, message is longer than 140 Chars" withTitle:@"Post Error" andIcon:[t TIFFRepresentation]];
	} else {
		NSLog(@"shorter");
		[twitterEngine sendUpdate:message];	
		[newTweetMessage setStringValue:@""];
		[self endSheet:sender];
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
		[self setConnected:[NSNumber numberWithBool:YES]];
		[statusItem setImage:[NSImage imageNamed:@"available.png"]];
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

			IXTwitterMessage *message = [[IXTwitterMessage alloc] init];
			[message setKind:twitterMessage];
			[message setName:name];
			[message setMessage:text];
			[message setPictureUsingUrl:profile_image_url];
			[message setTwitterId:twitter_id];
			[message setDate:created];
			[newTweets addObject:[message retain]];
			
			if(!launching)
				[growlController growl:text withTitle:name andIcon:[message picture_data]];
			
		}
		
		if(launching)
			launching = NO;
		
		NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:newTweets];
		[tmpArray addObjectsFromArray:[self twitts]];

		[self setTwitts:[NSArray arrayWithArray:tmpArray]];
		NSLog(@"twitts %@", twitts);
	}
}


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
			
			IXTwitterMessage *message = [[IXTwitterMessage alloc] init];
			[message setKind:twitterDirectMessage];
			[message setName:name];
			[message setMessage:text];
			[message setPictureUsingUrl:profile_image_url];
			[message setTwitterId:twitter_id];
			[message setDate:created];
			[newTweets addObject:[message retain]];
			
			
//			if(!launching)
			[growlController growl:text withTitle:name andIcon:[message picture_data] isSticky:YES];
			
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
@end
