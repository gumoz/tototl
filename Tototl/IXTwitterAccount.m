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
@synthesize receivedMessages;
@synthesize lastUpdateID;

- (id) init
{
	self = [super init];
	if (self != nil) {
		receivedMessages = [NSArray new];
		engine = [[MGTwitterEngine alloc] initWithDelegate:self];
		isConnected = NO;
	}
	return self;
}
-(void)connect{
	[engine setUsername:username password:password];
	NSString *aIdentifier = nil;
	aIdentifier = [engine checkUserCredentials];
	if(aIdentifier != nil)
		self.identifier = aIdentifier;
	
	NSLog(@"connectionIdentifier = %@", aIdentifier);
	
	isConnected = NO;
	self.statusPicture = [NSImage imageNamed:@"idle"];
	self.status = @"Connecting...";
		
	[NSTimer scheduledTimerWithTimeInterval:20
									 target:self 
								   selector:@selector(update)
								   userInfo:nil
									repeats:YES];
}
- (void)disconnect{
	NSLog(@"disconnect");
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
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
	id lastObject = [statuses lastObject];
	id updateID = [lastObject valueForKey:@"id"];
	NSLog(@"update id: %@", updateID);
	
	lastUpdateID = (long)[updateID longLongValue];
//	[engine getFollowedTimelineSinceID:lastUpdateID startingAtPage:0 count:3];
	self.receivedMessages = [receivedMessages arrayByAddingObjectsFromArray:statuses];
	//NSLog(@"receivedMessages: %@", receivedMessages);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
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
@end
