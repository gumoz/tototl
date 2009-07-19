//
//  IXTwitterMessagesWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/18/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTwitterAccount.h"
#import "MGTwitterEngine.h"

enum {
	NoAction = 0,
	ReplyAction = 1,
	DirectMessageAction = 2
};

@interface IXTwitterMessageWindowController : NSWindowController {

	IXTwitterAccount *account;

	float charactersLeft;
	int maxCharacters;
	int currentAction;
	long replyingToUpdateID;
	
	IBOutlet NSView *messagesView;
	IBOutlet NSView *updateView;
	IBOutlet NSView *topView;
	
	IBOutlet NSView *messagesContainerView;
	IBOutlet NSView *updateContainerView;
	IBOutlet NSView *topContainerView;
	
	IBOutlet NSTextField *updateMessageField;
	NSString *updateMessage;
	IBOutlet NSButton *updateMessageButton;
	IBOutlet NSButton *cancelActionButton;
}
@property (assign, readwrite) IXTwitterAccount *account;
@property (readwrite) float charactersLeft;
@property (readwrite) long replyingToUpdateID;
@property (assign, readwrite) NSString *updateMessage;
-(void)clean;
-(void)refresh;
-(void)count;

-(IBAction)toggleConnection:(id)sender;
-(IBAction)postUpdate:(id)sender;
-(IBAction)cancelAction:(id)sender;
-(IBAction)reply:(id)sender;
@end
