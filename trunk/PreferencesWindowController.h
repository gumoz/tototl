//
//  PreferencesWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/15/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGTwitterEngine.h"

@interface PreferencesWindowController : NSWindowController {
	IBOutlet NSUserDefaultsController *preferences;
	IBOutlet id profileView;
	IBOutlet id twitterView;
	IBOutlet id tototlView;
	IBOutlet id interfaceView;
	IBOutlet id updatesView;
	IBOutlet id aboutView;
    int currentViewTag;
	MGTwitterEngine *twitterEngine;
	IBOutlet id segmentedControl;
	NSArray *deliveryMethods;
	NSString *deliveryMethod;
}
@property (retain, readwrite) MGTwitterEngine *twitterEngine;
-(NSRect)newFrameForNewContentView:(NSView *)view;
-(NSView *)viewForTag:(int)tag;
-(IBAction)switchView:(id)sender;
-(IBAction)checkForUpdates:(id)sender;
-(IBAction)openIUseThis:(id)sender;
-(IBAction)openDonate:(id)sender;
-(IBAction)setProfile:(id)sender;
-(IBAction)resetDefaults:(id)sender;
@end
