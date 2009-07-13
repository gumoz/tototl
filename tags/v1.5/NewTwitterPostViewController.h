//
//  NewTwitterPostWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 28/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGTwitterEngine.h"
#import "GrowlController.h"

@interface NewTwitterPostViewController : NSViewController {

	id delegate;
	IBOutlet NSTextField *messageField;
	
	//we added this outlet because the binding is not working 
	IBOutlet NSTextField *messageCountField;
	NSString *message;
	NSNumber *messageCount; // fixme binding 
	MGTwitterEngine *twitterEngine;
	GrowlController *growlController;
	NSNumber *connected;
	NSColor *messageCountFontColor;
}
@property (copy, readwrite) NSNumber *connected;
@property (copy, readwrite) NSNumber *messageCount;
@property (retain, readwrite) GrowlController *growlController;
@property (retain, readwrite) id delegate;
@property (retain, readwrite) MGTwitterEngine *twitterEngine;
@property (copy, readwrite) NSString *message;

-(IBAction)cancel:(id)sender;
-(IBAction)post:(id)sender;
-(IBAction)messageCount:(id)sender;
-(void)countMessageLenght;
@end
