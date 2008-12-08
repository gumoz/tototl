//
//  IXSheetWindowController.m
//  IXCommons
//
//  Created by Gustavo Moya Ortiz on 22/09/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "IXSheetWindowController.h"


@implementation IXSheetWindowController

@synthesize sheetDelegate;

- (id) init
{
	self = [super init];
	if (self != nil) {
		sheetDelegate = self;
		_tag = 0;
	}
	return self;
}
- (NSInteger)tag {
    return _tag;
}

- (void)setTag:(NSInteger)value {
    if (_tag != value) {
		_tag = value;
	}
}
- (IBAction)launchSheet:(id)sender{
	NSWindow *sheet = [self windowForTag:[sender tag]];
	[self launchSheetUsingWindow:sheet];
}
-(IBAction)endSheet:(id)sender {
	NSWindow *sheet = [self windowForTag:[sender tag]];
	[self endSheetUsingWindow:sheet];
}
-(void)launchSheetUsingWindow:(NSWindow *)sheet
{
	if(sheet != nil)
	{
		[NSApp beginSheet:sheet
		   modalForWindow:[NSApp mainWindow]
			modalDelegate:sheetDelegate
		   didEndSelector:nil
			  contextInfo:nil];
	}
}
-(void)launchSheetWithTag:(int)tag{
	NSWindow *sheet = [self windowForTag:tag];
	[self launchSheetUsingWindow:sheet];
}
-(void)endSheetUsingWindow:(NSWindow *)sheet
{
	if(sheet != nil)
	{
		[sheet close];
		[NSApp endSheet:sheet];
	}
}
-(NSWindow *)windowForTag:(int)tag{
	
	if(tag == 0)
		return [self window];
	
	return nil;
}

@end
