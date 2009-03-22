//
//  IXWebService.h
//  IxayaWebServices
//
//  Created by Gustavo Moya on 4/23/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXWebServiceArgument.h"
#import "IXWSDelegateProtocol.h"


@interface IXWebService : NSObject {

	id delegate;
	NSURL *URI;
	NSString *stringURI;
	NSArray *parameters;
	NSString *kind;
	NSDictionary *dictionaryResponse;
	NSString *bodyResponse;
	NSString *apiKey;
}
@property (copy,readwrite) NSURL *URI;
@property (copy,readwrite) NSString *stringURI;
@property (copy,readwrite) id parameters;
@property (copy,readwrite) NSString *kind;
@property (copy,readwrite) NSDictionary *dictionaryResponse;
@property (copy,readwrite) NSString *bodyResponse;
@property (copy,readwrite) NSString *apiKey;

- (NSString *)delegate;
- (void)setDelegate:(NSString *)value;


- (BOOL)send;
- (BOOL)send:(id)sender;
//- (BOOL)invoke;

- (NSString *)encode;
@end
