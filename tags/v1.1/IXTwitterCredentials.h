//
//  IXTwitterCredentials.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXTwitterCredentials : NSObject {
	NSString *username;
	NSString *password;

}
@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSString *password;

@end
