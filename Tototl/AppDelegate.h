//
//  AppDelegate.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"
#import "IXTototlAccountsController.h"

@interface AppDelegate : NSObject {
	
	NSMutableArray *accounts;
}
@property (retain, readwrite) 	NSMutableArray *accounts;
- (void)openTwitterWindows;
- (void)connectAll;
- (IBAction)openPreferences:(id)sender;

@end
