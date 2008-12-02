//
//  AppController.m
//  Ixaya Twitter
//
//  Created by Gustavo Moya Ortiz on 20/11/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "AppController.h"
#import "NewTwitterPostViewController.h"
#import "TototlStatusItemView.h"

@implementation AppController
- (id) init
{
	self = [super init];
	if (self != nil) {
		shown = NO;
		// Create a TwitterEngine
	}
	return self;
}

-(void)awakeFromNib{
	ixayaTwitterController = [[IxayaTwitterWindowController alloc] init];
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:ixayaTwitterController];
	[ixayaTwitterController setTwitterEngine:twitterEngine];

	// Create an NSStatusItem.
	// Create an NSStatusItem.
    float width = 30.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
    [statusItem setView:[[[TototlStatusItemView alloc] initWithFrame:viewFrame controller:self] autorelease]];
	
	
//	statusItemController = [[TototlStatusItemViewController  alloc] init];
//	[statusItemController setController:self];
	[ixayaTwitterController setStatusItem:statusItem];
	

	[self show:self];

	[ixayaTwitterController performSelector:@selector(connect:) withObject:self];

}
-(void)singleClick{
	// not executed if menu
	NSLog(@"single click");
	
	[self newPost:self];
}
-(void)doubleClick{
// not executed if menu
	NSLog(@"double click");
	[self showOrHide:self];
}

-(IBAction)showOrHide:(id)sender{

	NSWindow *window = [ixayaTwitterController window];
	if([window isKeyWindow])
	{
		[window orderOut:self];	
	}
	else{
		[window makeKeyAndOrderFront:self];
		[window orderFrontRegardless];

	}
	
//	[self statusClicked];
}
-(IBAction)newPost:(id)sender{

}
-(IBAction)show:(id)sender{
	[[ixayaTwitterController window] makeKeyAndOrderFront:self];
	[[ixayaTwitterController window] orderFrontRegardless];
}
-(IBAction)hide:(id)sender{
	NSWindow *window = [ixayaTwitterController window];
	[window orderOut:self];
}
-(IBAction)close:(id)sender{
	[[ixayaTwitterController window] close];
	[NSApp terminate:self];
}
-(IBAction)checkForUpdates:(id)sender{
	[sparkleUpdater checkForUpdates:sender];
}
- (int)tag{
	return 0;
}
- (NSMenu *)barMenu {
    return [[barMenu retain] autorelease];
}

- (void)dettachTwitterPost{
	if (newTwitterPostWindow)
	{
		[[statusItem view] performSelector:@selector(handleSingleClick:) withObject:[NSEvent new]];
		[newTwitterPostWindow orderOut:self];
		[newTwitterPostWindow release];
		newTwitterPostWindow = nil;		
	}
}
- (void)toggleNewTwitterPost:(NSPoint)point{

	
	// Attach/detach window.
	if (!newTwitterPostWindow) {
		
		NewTwitterPostViewController *newView = [[NewTwitterPostViewController alloc] init];
		[newView setTwitterEngine:twitterEngine];
		[newView setDelegate:self];
		
		newTwitterPostWindow = [[MAAttachedWindow alloc] initWithView:[newView view] 
												attachedToPoint:point 
													   inWindow:nil 
														 onSide:MAPositionBottom 
													 atDistance:5.0];
		
//		[textField setTextColor:[newTwitterPostWindow borderColor]];
//		[textField setStringValue:@"Your text goes here..."];
		[newTwitterPostWindow makeKeyAndOrderFront:self];
		[newTwitterPostWindow orderFrontRegardless];
	} else {
		[newTwitterPostWindow orderOut:self];
		[newTwitterPostWindow release];
		newTwitterPostWindow = nil;
	}    
}
@end