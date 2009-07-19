//
//  IXTwitterAccount.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/23/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"
#import "MGTwitterEngine.h"

@interface IXTwitterAccount : IXTototlAccount {
	MGTwitterEngine *engine;
	NSString *location;
	NSNumber *updateFrequency;
	NSString *notificationsDeliveryMethod;
	NSString *identifier;
	NSArray *receivedMessages;
	long lastUpdateID;
}
@property (retain, readwrite) NSArray *receivedMessages;
@property (retain, readonly) MGTwitterEngine *engine;
@property (retain, readwrite) NSString *identifier;
@property (retain, readwrite) NSString *location;
@property (retain, readwrite) NSNumber *updateFrequency;
@property (retain, readwrite) NSString *notificationsDeliveryMethod;
@property long lastUpdateID;

- (void) sendLocationToTwitter;
- (void)update;
@end
