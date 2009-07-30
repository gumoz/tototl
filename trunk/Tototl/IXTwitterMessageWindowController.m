//
//  IXTwitterMessagesWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/18/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXTwitterMessageWindowController.h"


@implementation IXTwitterMessageWindowController

@synthesize charactersLeft, account, updateMessage, replyingToUpdateID;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self initWithWindowNibName:@"IXTwitterMessageWindow"];
		updateMessage = @"";
		maxCharacters = 140;
		charactersLeft = 140;
		currentAction = NoAction;
	}
	return self;
}
-(void)awakeFromNib{
	[topContainerView addSubview:topView];
	[messagesContainerView addSubview:messagesView];
	[updateContainerView addSubview:updateView];
	[cancelActionButton setHidden:YES];
}
-(void)clean{
	self.charactersLeft = maxCharacters;
	self.updateMessage = @"";
	[cancelActionButton setTitle:@"cancel"];
	[cancelActionButton setHidden:YES];
	[updateMessageButton setTitle:@"Update"];
}
-(void)count{
	int lenght = [updateMessage length];
	self.charactersLeft = maxCharacters - lenght;
}
-(IBAction)toggleConnection:(id)sender{
	if([account isConnected])
		[account disconnect];
	else
		[account connect];
}
-(IBAction)postUpdate:(id)sender{
	switch (currentAction) {
		default: case NoAction:
			[account.engine sendUpdate:updateMessage];
			break;
		case ReplyAction:
			[account.engine sendUpdate:updateMessage inReplyTo:replyingToUpdateID];
			replyingToUpdateID = -1;
			break;
	}
	[self clean];
}
-(IBAction)cancelAction:(id)sender{
	[self clean];
}

-(IBAction)reply:(id)sender{
	currentAction = ReplyAction;	
	long tag = [sender tag];
	replyingToUpdateID = tag;
	[cancelActionButton setTitle:@"replying to a message"];
	[cancelActionButton setHidden:NO];
	[updateMessageButton setTitle:@"Reply"];
}
-(void)setUpdateMessage:(NSString *)message{
	if(updateMessage != message)
	{
		updateMessage = message;
		[self count];
	}
}
-(void)getFolowers{
	[account.engine getFollowersIncludingCurrentStatus:YES];
}
@end
