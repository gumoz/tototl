//
//  IXEditAccountWindow.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"

@interface IXTototlEditAccountWindowController : NSWindowController {

	IXTototlAccount *account;
}
@property (assign, readwrite) IXTototlAccount *account;
+ (void)sheetWithAccount:(IXTototlAccount *)account forWindow:(NSWindow *)window;

-(IBAction)close:(id)sender;
@end
