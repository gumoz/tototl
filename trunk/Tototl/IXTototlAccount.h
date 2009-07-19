//
//  IXTototlAccount.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EMKeychainProxy.h"

@interface IXTototlAccount : NSObject {

	NSString *kind;
	NSNumber *enabled;
	NSString *username;
	NSString *password;
	NSNumber *saveInKeychain;
	BOOL isConnected;
	
	NSImage *kindPicture;
	NSImage *statusPicture;
	NSString *status;
	NSImage *picture;
}
@property (copy, readwrite) NSString *kind;
@property (copy, readwrite) NSNumber *enabled;
@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSString *password;
@property (copy, readwrite) NSNumber *saveInKeychain;

@property (readonly) BOOL isConnected;
@property (copy, readwrite) NSImage *kindPicture;
@property (assign, readwrite) NSImage *statusPicture;
@property (copy, readwrite) NSString *status;
@property (copy, readwrite) NSImage *picture;

- (EMGenericKeychainItem *)retrieveKeychainItem;
- (void)retrievePasswordFromKeychain;
- (void)savePasswordInKeychain;
- (void)save;
- (void)connect;
- (void)disconnect;
- (void)readDefaultsFromDictionary:(NSDictionary *)defaultsDictionary;
- (NSDictionary *)defaultsDictionary;

@end
