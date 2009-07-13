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
#import <HDCrashReporter/crashReporter.h>

@implementation AppController

@synthesize growlController, connected;
- (id) init
{
	self = [super init];
	if (self != nil) {
		
		//submit crash report
		if ([HDCrashReporter newCrashLogExists])
			[HDCrashReporter doCrashSubmitting];
		
//		self release
		shown = NO;
		// Create a TwitterEngine
		growlController = [[GrowlController alloc] init];
		connected = [NSNumber numberWithBool:NO];
	}
	return self;
}

-(void)awakeFromNib{
	ixayaTwitterController = [[IxayaTwitterWindowController alloc] init];
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:ixayaTwitterController];
	[ixayaTwitterController setTwitterEngine:twitterEngine];
	[ixayaTwitterController setGrowlController:growlController];

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
	
	// Attach/detach window
	if (!newTwitterPostWindow) {
		NewTwitterPostViewController *newView = [[NewTwitterPostViewController alloc] init];
		[newView setTwitterEngine:twitterEngine];
		[newView setDelegate:self];
		[newView setConnected:connected];
		
		newTwitterPostWindow = [[MAAttachedWindow alloc] initWithView:[newView view] 
												attachedToPoint:point 
													   inWindow:nil 
														 onSide:MAPositionBottom 
													 atDistance:5.0];
		
		NSData *borderColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"borderColor"];
		NSData *backgroundColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
		
		if(borderColorData)
		{
			NSKeyedUnarchiver *borderColorUnarchiver = [[NSUnarchiver alloc] initForReadingWithData:borderColorData];	
			NSColor *borderColor = [borderColorUnarchiver decodeObject];
			[newTwitterPostWindow setBorderColor:borderColor];		
			[borderColorUnarchiver release];
		}
		
		if(backgroundColorData)
		{
			NSKeyedUnarchiver *backgroundColorUnarchiver = [[NSUnarchiver alloc] initForReadingWithData:backgroundColorData];	
			NSColor *backgroundColor = [backgroundColorUnarchiver decodeObject];
			[newTwitterPostWindow setBackgroundColor:backgroundColor];	
			[backgroundColorUnarchiver release];

		}
		
		[newTwitterPostWindow makeKeyAndOrderFront:self];
		[newTwitterPostWindow orderFrontRegardless];
	} else {
		[newTwitterPostWindow orderOut:self];
		[newTwitterPostWindow release];
		newTwitterPostWindow = nil;
	}    

}
@end
