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
	IBOutlet NSTextField *message;
	MGTwitterEngine *twitterEngine;
	GrowlController *growlController;
}
@property (retain, readwrite) GrowlController *growlController;
@property (retain, readwrite) id delegate;
@property (retain, readwrite) MGTwitterEngine *twitterEngine;
		   
-(IBAction)cancel:(id)sender;
-(IBAction)post:(id)sender;
@end
