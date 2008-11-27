//
//  IXTwitterMessage.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXTwitterMessage.h"


@implementation IXTwitterMessage

@synthesize picture, picture_data, name, message, twitterId;
-(void)setPictureUsingUrl:(NSString *)url{
	NSImage *profile_image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	[self setPicture:profile_image];
	[self setPicture_data:[profile_image TIFFRepresentation]];
}
-(NSString *)description{

	NSString *desc = [NSString stringWithFormat:@"Id: %@, by: %@, Message %@", twitterId, name, message];
	return desc;
}
@end
