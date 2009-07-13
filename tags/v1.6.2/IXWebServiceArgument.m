//
//  IXWebServiceArgument.m
//  IxayaWebServices
//
//  Created by Gustavo Moya on 4/23/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXWebServiceArgument.h"


@implementation IXWebServiceArgument

@synthesize argument;
@synthesize argumentValue;

- (id) initWithArgument:(NSString *)anArgument andValue:(NSString *)aValue {
	self = [super init];
	if (self != nil) {
		argument = anArgument;
		argumentValue = aValue;
	}
	return self;
}

@end
