//
//  IXWebServiceArgument.h
//  IxayaWebServices
//
//  Created by Gustavo Moya on 4/23/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXWebServiceArgument : NSObject {
	
	NSString *argument;
	NSString *argumentValue;
}
@property (copy,readwrite) NSString *argument;
@property (copy,readwrite) NSString *argumentValue;

- (id) initWithArgument:(NSString *)anArgument andValue:(NSString *)aValue;
@end
