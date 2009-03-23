//
//  PreferencesWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/22/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController {

	NSMutableArray *accounts;
}
@property (retain, readwrite) NSMutableArray *accounts;
-(void)saveAccounts;
@end
