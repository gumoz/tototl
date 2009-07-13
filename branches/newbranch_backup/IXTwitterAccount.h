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
}
@property (copy, readwrite) NSString *location;
@property (copy, readwrite) NSNumber *updateFrequency;
@property (copy, readwrite) NSString *notificationsDeliveryMethod;
@end
