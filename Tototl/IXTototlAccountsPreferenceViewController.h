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
#import "AccountsController.h"

@interface IXTototlAccountsPreferenceViewController : NSViewController <MBPreferencesModule> {

	IBOutlet NSArrayController *accountsArrayController;
	NSMutableArray *accounts;
}
@property (retain, readwrite) NSMutableArray *accounts;

- (NSString *)identifier;
- (NSImage *)image;

-(IBAction)editSelectedAccount:(id)sender;
@end
