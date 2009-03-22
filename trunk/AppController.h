//
//  AppController.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IxayaTwitterWindowController.h"
#import "MAAttachedWindow.h"
#import "TototlStatusItemViewController.h"
#import <Growl/Growl.h>
#import <Sparkle/Sparkle.h>
#import "TototlStatusItemView.h"
#import "CTBadge.h"

@class MAAttachedWindow;

enum {
	InterfaceOld = 1,
	InterfaceTiny = 2,
	InterfaceMilky = 3,
	InterfaceiChat = 4,
};

enum 
{
	twitterMessage = 0,
	twitterDirectMessage = 1
};

@interface AppController : NSObject  {

	CTBadge *badge;
	MAAttachedWindow *newTwitterPostWindow;
	MGTwitterEngine *twitterEngine;
	IxayaTwitterWindowController *ixayaTwitterController;
//	TototlStatusItemViewController *statusItemController;
	TototlStatusItemView *statusItemView;
	
	GrowlController *growlController;
	IBOutlet SUUpdater *sparkleUpdater;
	NSStatusItem *statusItem;
	IBOutlet NSMenu *barMenu; 
	int tag;
	BOOL shown;
	NSNumber *connected;
	NSUserDefaults *defaults;
}
@property (copy, readwrite) NSNumber *connected;
@property (retain, readwrite) GrowlController *growlController;
- (NSMenu *)barMenu;

-(int)tag;
-(void)singleClick;
-(void)doubleClick;
-(IBAction)newPost:(id)sender;
-(IBAction)showOrHide:(id)sender;
-(IBAction)show:(id)sender;
-(IBAction)hide:(id)sender;
-(IBAction)close:(id)sender;
-(IBAction)checkForUpdates:(id)sender;
- (void)toggleNewTwitterPost:(NSPoint)point;
- (void)dettachTwitterPost;
- (void)gotMessages:(int)amount;
- (void)gotDirectMessages:(int)amount;
- (void)setBadgeWithAmount:(int)amount;
@end