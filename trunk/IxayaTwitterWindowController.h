//
//  IxayaTwitterWindowController.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXSheetWindowController.h"
#import "MGTwitterEngine.h"
#import "GrowlController.h"
//http://apiwiki.twitter.com/REST+API+Documentation
	
@interface IxayaTwitterWindowController : IXSheetWindowController <MGTwitterEngineDelegate> {

	IBOutlet NSWindow *credentialsWindow;
	IBOutlet NSWindow *twitWindow;
	IBOutlet NSObjectController *credentials;
	IBOutlet NSArrayController *twittsArrayController;
	NSMutableArray *twitts;
	MGTwitterEngine *twitterEngine;
	NSNumber *connected;
	IBOutlet NSTextField *newTweetMessage;
	GrowlController *growlController;
	BOOL launching;
	NSStatusItem *statusItem;
}
@property (copy, readwrite) NSMutableArray *twitts;
@property (copy, readwrite) 	NSNumber *connected;
@property (retain, readwrite) 	NSStatusItem *statusItem;
-(IBAction)connect:(id)sender;
-(IBAction)postTweet:(id)sender;
-(void)update;
@end
