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
#import "SmartCrashReportsAPI.h"
//#import "SmartCrashReportsInstall.h"
@implementation AppController

@synthesize growlController, connected;
- (id) init
{
	self = [super init];
	if (self != nil) {
		//submit crash report		
//		Boolean authenticationWillBeRequired = FALSE;
//		if (UnsanitySCR_CanInstall(&authenticationWillBeRequired))
//			UnsanitySCR_Install(authenticationWillBeRequired ? kUnsanitySCR_GlobalInstall : 0);
		
//		self release
		shown = NO;
		// Create a TwitterEngine
		growlController = [[GrowlController alloc] init];
		connected = [NSNumber numberWithBool:NO];
		defaults = [NSUserDefaults standardUserDefaults];
		
		//load hot key bundle
		[[NSBundle bundleWithPath:[[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:@"BSHotKey.bundle"]] load];
	}
	return self;
}
//- (void)finishLaunching
//{
//	NSMutableArray *BSHotKey_MyHotKey = [[NSMutableArray alloc] init];
//	[BSHotKey_MyHotKey addObject:[NSNumber numberWithInt:768]];
//	[BSHotKey_MyHotKey addObject:[NSNumber numberWithInt:17]];
//	[BSHotKey_MyHotKey addObject:[NSNumber numberWithInt:116]];
//	[defaults setObject:BSHotKey_MyHotKey forKey:@"BSHotKey_MyHotKey"];
//	[defaults synchronize];
//	
//	[[BSHotKeyManager defaultManager] hotKeyNamed:@"MyHotKey" withAction:@selector(myHotKeyPressed:) target:self];
//	[[BSHotKeyManager defaultManager] setReleaseAction:@selector(myHotKeyReleased:)];
//	[super finishLaunching]; 
//}

- (void)myHotKeyPressed:(id)name
{
	[self show:self];
//	[self log:@"hotkey %@ was pressed :-D",name];
}
- (void)myHotKeyReleased:(id)name
{
//	[self log:@"hotkey %@ was released :-D",name];
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
//	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
//	NSString *username = [defaults valueForKey:@"username"];
//	NSString *password = [defaults valueForKey:@"password"];
//	if(![username isEqualToString:@""] && ![password isEqualToString:@""] && username && password)
//	{
//		NSLog(@"username and password");
//		[ixayaTwitterController performSelector:@selector(connect:) withObject:self];
//	}
	
	
	
	if ([defaults boolForKey:@"DockIcon"]) {
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		// enable menu bar
		SetSystemUIMode(kUIModeNormal, 0);
		// switch to Dock.app
		[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil];
		// switch back
		[[NSApplication sharedApplication] activateIgnoringOtherApps:TRUE];
	}
	
}
-(void)singleClick{

	BOOL show = [defaults boolForKey:@"SingleClickOpenWindow"];
	// not executed if menu
	NSLog(@"single click %d", show);
	if (show)
	{
		[self showOrHide:self];
	} else {
		[self newPost:self];	
	}
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
- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification{
	NSLog(@"aa");
	[self show:self];
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
	NSLog(@"bb");
	[self show:self];
	return NO;
}


@end
