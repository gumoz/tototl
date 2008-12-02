//
//  AppController.h
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IxayaTwitterWindowController.h"

@interface AppController : NSObject  {
	IxayaTwitterWindowController *ixayaTwitterController;
	NSStatusItem *statusItem;
	IBOutlet NSMenu *barMenu; 
	int tag;
	BOOL shown;
}
- (int)tag;
-(void)statusClicked;
-(IBAction)showOrHide:(id)sender;
-(IBAction)show:(id)sender;
-(IBAction)hide:(id)sender;
-(IBAction)close:(id)sender;
@end