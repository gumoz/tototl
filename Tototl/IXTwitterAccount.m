//
//  IXTwitterAccount.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/23/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTwitterAccount.h"


@implementation IXTwitterAccount
 
@synthesize engine;
@synthesize location;
@synthesize updateFrequency;
@synthesize notificationsDeliveryMethod;
@synthesize identifier;
@synthesize lastUpdateID;


@synthesize friendStatuses;
@synthesize directMessages;
@synthesize followers;
@synthesize friends;

- (id) init
{
	self = [super init];
	if (self != nil) {
		friendStatuses = [NSArray new];
		directMessages = [NSArray new];
		followers = [NSArray new];
		friends = [NSArray new];
		engine = [[MGTwitterEngine alloc] initWithDelegate:self];
		isConnected = NO;
		self.updateFrequency = [NSNumber numberWithInt:120];
		self.location = @"In Tototl Land";
		self.notificationsDeliveryMethod = @"none";
	}
	return self;
}
-(void)connect {
	[engine setUsername:username password:password];
	NSString *aIdentifier = nil;
	aIdentifier = [engine checkUserCredentials];
	if(aIdentifier != nil)
		self.identifier = aIdentifier;
	
	NSLog(@"connectionIdentifier = %@", aIdentifier);
	
	isConnected = NO;
	self.statusPicture = [NSImage imageNamed:@"idle"];
	self.status = @"Connecting...";
		
	if(self.updateFrequency == nil)
		self.updateFrequency = [NSNumber numberWithInt:120];
	
	[NSTimer scheduledTimerWithTimeInterval:[self.updateFrequency intValue]
									 target:self 
								   selector:@selector(update)
								   userInfo:nil
									repeats:YES];
	[engine getFollowedTimelineSinceID:lastUpdateID startingAtPage:0 count:0];	
}
- (void)disconnect{
	NSLog(@"disconnect");
	[engine endUserSession];
	[engine closeConnection:self.identifier];
}
#pragma mark MGTwitterEngineDelegate methods

//-(void)connection:(MGTwitterHTTPURLConnection *)connection didFailWithError:(NSError *)error{
//	isConnected = NO;
//}

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);

	isConnected = NO;
	self.statusPicture = [NSImage imageNamed:@"away"];
	self.status = @"Disconnected";
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
	NSString *growlMessage = [NSString stringWithFormat:@"%d New Statuses", [statuses count]];
	[[IXTototlGrowlController sharedController] growl:growlMessage withTitle:@"New Statuses"];
	
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
	id lastObject = [statuses lastObject];
	id updateID = [lastObject valueForKey:@"id"];
	NSLog(@"update id: %@", updateID);
	
	lastUpdateID = (long)[updateID longLongValue];
//	[engine getFollowedTimelineSinceID:lastUpdateID startingAtPage:0 count:3];
	NSArray *statusesToSort = [friendStatuses arrayByAddingObjectsFromArray:statuses];
	
	NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"status.created_at" ascending:NO];
	NSArray *sortedStatuses = [statusesToSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
	self.friendStatuses = sortedStatuses;
	//NSLog(@"receivedMessages: %@", receivedMessages);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
	NSString *growlMessage = [NSString stringWithFormat:@"%d New Direct Messages Received", [messages count]];
	[[IXTototlGrowlController sharedController] growl:growlMessage withTitle:@"New Direct Messages"];
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
	isConnected = YES;
	self.statusPicture = [NSImage imageNamed:@"available"];
	self.status = @"Connected";
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}

- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)imageReceived:(NSImage *)image forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
    
    // Save image to the Desktop.
    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", connectionIdentifier] stringByExpandingTildeInPath];
    [[image TIFFRepresentation] writeToFile:path atomically:NO];
}

- (void)connectionFinished
{
	NSLog(@"Connection Finished: %@", self.identifier);
	isConnected = NO;
//	if ([engine numberOfConnections] == 0)
//	{
//		[NSApp terminate:self];
//	}
}
- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}
- (void)readDefaultsFromDictionary:(NSDictionary *)defaultsDictionary{
	self.location = [defaultsDictionary valueForKey:@"location"];
	self.updateFrequency = [defaultsDictionary valueForKey:@"updateFrequency"];
	self.notificationsDeliveryMethod = [defaultsDictionary valueForKey:@"notificationsDeliveryMethod"];	
	[super readDefaultsFromDictionary:defaultsDictionary];
}
- (NSDictionary *)defaultsDictionary{
	
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									self.location, @"location",
									self.updateFrequency, @"updateFrequency",
									self.notificationsDeliveryMethod, @"notificationsDeliveryMethod",
									nil];	
	[tmpDict addEntriesFromDictionary:[super defaultsDictionary]];
	return [NSDictionary dictionaryWithDictionary:tmpDict];
}

// send location to twitter
- (void) sendLocationToTwitter{
	[engine setLocation:self.location];
}

- (void)update{
	[engine getFollowedTimelineSinceID:self.lastUpdateID startingAtPage:0 count:0];
}
- (IBAction)block:(id)sender{
//	[engine block:username];
}
- (void) clearsCookies{
	[engine clearsCookies];
}
@end
