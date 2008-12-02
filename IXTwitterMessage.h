//
//  IXTwitterMessage.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXTwitterMessage : NSObject {
	NSImage *picture;
	NSData *picture_data;
	NSString *name;
	NSString *message;
	NSString *twitterId;
	NSDate *date;
}

@property (copy, readwrite) NSImage *picture;
@property (copy, readwrite)	NSData *picture_data;
@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *message;
@property (copy, readwrite) NSString *twitterId;
@property (copy, readwrite) NSDate *date;

-(void)setPictureUsingUrl:(NSString *)url;

@end
