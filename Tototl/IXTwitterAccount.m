//
//  IXTwitterAccount.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/23/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTwitterAccount.h"


@implementation IXTwitterAccount

@synthesize location;
@synthesize updateFrequency;
@synthesize notificationsDeliveryMethod;
- (id) init
{
	self = [super init];
	if (self != nil) {
		engine = [[MGTwitterEngine alloc] initWithDelegate:self];
	}
	return self;
}
-(void)connect{
	[engine setUsername:username password:password];
	NSString *connectionIdentifier = [engine checkUserCredentials];
	NSLog(@"connectionIdentifier = %@", connectionIdentifier);
}

#pragma mark MGTwitterEngineDelegate methods

//-(void)connection:(MGTwitterHTTPURLConnection *)connection didFailWithError:(NSError *)error{
//	isConnected = NO;
//}

- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
	isConnected = YES;
	statusPicture = [NSImage imageNamed:@"available"];
	status = @"Connected";
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);

	isConnected = NO;
	statusPicture = [NSImage imageNamed:@"away"];
	status = @"Disconnected";
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
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
	if ([engine numberOfConnections] == 0)
	{
		[NSApp terminate:self];
	}
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
@end
