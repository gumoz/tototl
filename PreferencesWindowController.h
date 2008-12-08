//
//  PreferencesWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/15/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesWindowController : NSWindowController {
	IBOutlet id preferences;
	IBOutlet id twitterView;
	IBOutlet id tototlView;
	IBOutlet id aboutView;
    int currentViewTag;
}
-(NSRect)newFrameForNewContentView:(NSView *)view;
-(NSView *)viewForTag:(int)tag;
-(IBAction)switchView:(id)sender;
-(IBAction)checkForUpdates:(id)sender;
-(IBAction)openIUseThis:(id)sender;
@end
