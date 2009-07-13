//
//  IXTototlAccountsPreferenceViewController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"
#import "MBPreferencesController.h"

@interface IXTototlAccountsPreferenceViewController : NSViewController <MBPreferencesModule> {

	NSMutableArray *accounts;
	NSArray *kinds;
}
@property (retain, readwrite) NSArray *kinds;
@property (retain, readwrite) NSMutableArray *accounts;
-(void)saveAccounts;

- (NSString *)identifier;
- (NSImage *)image;

-(void)readAccountsFromDefaults;
- (Class)accountFromKind:(NSString *)kind;
@end
