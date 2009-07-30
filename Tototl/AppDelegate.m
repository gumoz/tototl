//
//  AppDelegate.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/21/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "AppDelegate.h"
#import "IXTwitterAccount.h"
#import "IXPreferencesController.h"
#import "IXTwitterMessageWindowController.h"

@implementation AppDelegate

@synthesize accounts;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.accounts = [[IXTototlAccountsController sharedController] accounts];
		[self openTwitterWindows];
		[self connectAll];
	}
	return self;
}
- (void)awakeFromNib{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	// check if dock icon
	if ([defaults boolForKey:@"dockIcon"]) {
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
- (void)openTwitterWindows{

	for(IXTwitterAccount *account in accounts)
	{
		if([[account enabled] boolValue])
		{
			IXTwitterMessageWindowController *windowController = [IXTwitterMessageWindowController new];
			[windowController setAccount:account];
			[windowController showWindow:self];
		}
	}
}
- (void)connectAll{
	for(IXTototlAccount *account in accounts)
	{
		if([[account enabled] boolValue])
		{
			[account connect];
		}
	}
}
- (IBAction)openPreferences:(id)sender{	
	[[IXPreferencesController sharedController] showWindow:sender];
}


- (void)applicationDidChangeScreenParameters:(NSNotification *)aNotification{
//	[self show:self];
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
//	[self singleClick];
	return NO;
}
@end
