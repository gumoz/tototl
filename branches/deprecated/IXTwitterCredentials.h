//
//  IXTwitterCredentials.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EMKeychainProxy.h"

@interface IXTwitterCredentials : NSObject {
	NSString *username;
	NSString *password;
	EMGenericKeychainItem *keychainItem;
}
@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSString *password;

- (void)read;
- (void)save;
- (void)synchronize;
- (IBAction)save:(id)sender;
- (IBAction)synchronize:(id)sender;
@end
