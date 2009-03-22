//
//  IXWebService.m
//  IxayaWebServices
//
//  Created by Gustavo Moya on 4/23/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXWebService.h"


@implementation IXWebService

@synthesize URI;
@synthesize stringURI;
@synthesize parameters;
@synthesize kind;
@synthesize dictionaryResponse;
@synthesize bodyResponse;
@synthesize apiKey;

- (NSString *)delegate {
    return [[delegate retain] autorelease];
}

- (void)setDelegate:(NSString *)value {
    if (delegate != value) {
        delegate = value;
    }
}

- (BOOL) send:(id)sender
{
	delegate = sender;
	return [self send];
}
- (BOOL) send
{		
	BOOL sent = NO;
	if(URI == nil)
		if(stringURI != nil)
			URI = [NSURL URLWithString:stringURI];
		else
			return NO;
	
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:URI];
	[urlRequest setHTTPMethod:kind]; //POST
	
	NSString *postData = [self encode];
	NSLog(@"postData %@", postData);
	[urlRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	if (connectionResponse) {
		sent = YES;
		return YES;
	} else {
		sent = NO;
		return NO;		
	}
	return NO;
}

- (NSString *)encode{
	NSString *postData = nil;
	for(IXWebServiceArgument *argument in parameters)	
	{
		if(postData == nil)
			postData = [NSString stringWithFormat:@"%@=%@", argument.argument, argument.argumentValue];	
		else
			postData = [NSString stringWithFormat:@"%@&%@=%@", postData, argument.argument, argument.argumentValue];
		
	}
	
	if(postData != nil && apiKey != nil)
		postData = [NSString stringWithFormat:@"%@&api_key=%@", postData, apiKey];
	
	return postData;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{	
	if(delegate != nil)
	{
		if([delegate conformsToProtocol:@protocol(IXWSDelegate)])
		{
			dictionaryResponse = [response allHeaderFields];
			[delegate response:nil fromService:self]; 
			NSLog([connection description]);
		}
	}
}
@end
