//
//  AppDelegate.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"

@interface AppDelegate : NSObject {

	NSArray *accounts;
}
@property (retain, readwrite) 	NSArray *accounts;
- (void)connectAll;
- (Class)accountFromKind:(NSString *)kind;
-(void)readAccountsFromDefaults;
- (IBAction)openPreferences:(id)sender;
@end
