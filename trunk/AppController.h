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
#import <Sparkle/Sparkle.h>

@class MAAttachedWindow;
@interface AppController : NSObject  {

	MAAttachedWindow *newTwitterPostWindow;
	MGTwitterEngine *twitterEngine;
	IxayaTwitterWindowController *ixayaTwitterController;
//	TototlStatusItemViewController *statusItemController;
	IBOutlet SUUpdater *sparkleUpdater;
	NSStatusItem *statusItem;
	IBOutlet NSMenu *barMenu; 
	int tag;
	BOOL shown;
}
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
@end