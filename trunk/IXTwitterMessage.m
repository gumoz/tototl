//
//  IXTwitterMessage.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXTwitterMessage.h"
#import <AutoHyperlinks/AutoHyperlinks.h>

@implementation IXTwitterMessage

@synthesize kind;
@synthesize picture, picture_data, name, message, attributedMessage, twitterId, date, screenName;
@synthesize tooltip;
enum 
{
	twitterMessage = 0,
	twitterDirectMessage = 1
};

-(void)setPictureUsingUrl:(NSString *)url{
	NSImage *profile_image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	[self setPicture:profile_image];
	[self setPicture_data:[profile_image TIFFRepresentation]];
}
-(NSString *)description{

	NSString *desc = [NSString stringWithFormat:@"Id: %@, by: %@, Message %@", twitterId, name, message];
	return desc;
}
- (void)setMessage:(NSString *)value {
    if (message != value) {
        [message release];
        message = [value copy];

		AHHyperlinkScanner *hlscan = [AHHyperlinkScanner hyperlinkScannerWithString:value];
		
		NSAttributedString *newText = [hlscan linkifiedString];
		AHMarkedHyperlink *hyperlink = [hlscan nextURI];
		NSURL *url = [hyperlink URL];
		
//		IXWebService *getLocation = [[IXWebService alloc] init];
//		[getLocation setURI:url];
//		[getLocation setKind:@"GET"];
//		[getLocation send:self];
		[self setAttributedMessage:newText];

    }
}
- (void)response:(NSString *)response fromService:(id)service{
//	NSDictionary *resp = [service dictionaryResponse]; 
//	NSLog(@"resp: %@", resp);
//	[self setTooltip:[resp valueForKey:@"Location"]];
//	NSLog(tooltip);
}


@end
