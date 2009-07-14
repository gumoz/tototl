//
//  AccountsController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlAccount.h"

@interface AccountsController : NSObject {
	
	NSMutableArray *accounts;
}
@property (retain, readwrite) NSMutableArray *accounts;
-(void)saveAccounts;

/**
 * @name        Accessing the Shared Instance
 */

/**
 * @brief       The shared accounts controller 
 *              All interaction with accounts should be done through this controller.
 */
+ (AccountsController *)sharedController;
- (Class)accountFromKind:(NSString *)kind;
@end
