//
//  IxayaTwitterWindowController.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

//http://tototl.googlecode.com/files/Tototl.xml

#import <Cocoa/Cocoa.h>
#import "IXSheetWindowController.h"
#import "MGTwitterEngine.h"
#import "GrowlController.h"
#import "PreferencesWindowController.h"
#import <RBSplitView/RBSplitView.h>
//http://apiwiki.twitter.com/REST+API+Documentation
	
@interface IxayaTwitterWindowController : IXSheetWindowController <MGTwitterEngineDelegate> {

	IBOutlet NSWindow *credentialsWindow;
	IBOutlet NSWindow *twitWindow;
	IBOutlet NSObjectController *credentials;
	IBOutlet NSArrayController *twittsArrayController;
	NSArray *twitts;
	NSUserDefaults *defaults;
	MGTwitterEngine *twitterEngine;
	NSNumber *connected;
	IBOutlet NSTextField *newTweetMessage;
	IBOutlet NSButton *configurationButton;
	GrowlController *growlController;
	BOOL launching;
	NSStatusItem *statusItem;
}
@property (retain, readwrite) GrowlController *growlController;
@property (retain, readwrite) MGTwitterEngine *twitterEngine;
@property (copy, readwrite) NSArray *twitts;
@property (copy, readwrite) 	NSNumber *connected;
@property (retain, readwrite) 	NSStatusItem *statusItem;
-(IBAction)configuration:(id)sender;
-(IBAction)connect:(id)sender;
-(IBAction)postTweet:(id)sender;
-(void)update;
-(IBAction)close:(id)sender;
@end
