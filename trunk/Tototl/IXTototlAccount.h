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
	NSString *username;
	NSString *password;
	NSNumber *saveInKeychain;
	EMGenericKeychainItem *keychainItem;

}
@property (copy, readwrite) NSString *kind;
@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSString *password;
@property (copy, readwrite) NSNumber *saveInKeychain;


- (EMGenericKeychainItem *)retrieveKeychainItem;
- (void)retrievePasswordFromKeychain;
- (void)save;
@end
