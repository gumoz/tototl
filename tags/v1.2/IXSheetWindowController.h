//
//  IXSheetWindowController.h
//  IXCommons
//
//  Created by Gustavo Moya Ortiz on 22/09/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXSheetWindowController : NSWindowController {
	
	id sheetDelegate;
	NSInteger _tag;
}
- (NSInteger)tag;
- (void)setTag:(NSInteger)value;
@property (retain, readwrite) id sheetDelegate;
#pragma mark sheet controls
- (IBAction)launchSheet:(id)sender;
- (void)launchSheetWithTag:(int)tag;
- (void)launchSheetUsingWindow:(NSWindow *)sheet;
- (IBAction)endSheet:(id)sender;
- (void)endSheetUsingWindow:(NSWindow *)sheet;
-(NSWindow *)windowForTag:(int)tag;
@end
