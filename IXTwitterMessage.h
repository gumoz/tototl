//
//  IXTwitterMessage.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXWebService.h"
#import "IXWSDelegateProtocol.h"

@interface IXTwitterMessage : NSObject <IXWSDelegate> {
	
	int kind;
	NSImage *picture;
	NSData *picture_data;
	NSString *name;
	NSString *message;
	NSAttributedString *attributedMessage;
	NSString *twitterId;
	NSDate *date;
	NSString *screenName;
	NSString *tooltip;
}
@property int kind;
@property (copy, readwrite) NSImage *picture;
@property (copy, readwrite)	NSData *picture_data;
@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *message;
@property (copy, readwrite) NSAttributedString *attributedMessage;
@property (copy, readwrite) NSString *twitterId;
@property (copy, readwrite) NSDate *date;
@property (copy, readwrite) NSString *screenName;
@property (copy, readwrite) NSString *tooltip;
-(void)setPictureUsingUrl:(NSString *)url;

@end
