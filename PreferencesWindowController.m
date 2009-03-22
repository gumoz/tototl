//
//  PreferencesWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/15/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

@synthesize twitterEngine;

-(id)init {
    self = [super initWithWindowNibName:@"PreferencesWindow"];
	deliveryMethods = [NSArray arrayWithObjects:@"none", @"im", @"sms", nil];
	
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	deliveryMethod = [defaults objectForKey:@"deliveryMethod"];
	if(deliveryMethod == nil)
			deliveryMethod = @"none";
    return self;
}

- (void)awakeFromNib{
    [[self window] setContentSize:[profileView frame].size];
    [[[self window] contentView] addSubview:profileView];
    [[[self window] contentView] setWantsLayer:YES];
}
-(NSRect)newFrameForNewContentView:(NSView *)view {
    NSWindow *window = [self window];
    NSRect newFrameRect = [window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}
-(NSView *)viewForTag:(int)tag {
    NSView *view = nil;
    switch(tag) {
		case 0: view = profileView; break;
		case 1: default: view = twitterView; break;
		case 2: view = tototlView; break;
		case 3: view = interfaceView; break;
		case 4: view = updatesView; break;
		case 5: view = aboutView; break;			
    }
    return view;
}
-(IBAction)switchView:(id)sender {
	
	// Figure out the new view, the old view, and the new size of the window
	int tag = [sender tag];
	NSView *view = [self viewForTag:tag];
	NSView *previousView = [self viewForTag: currentViewTag];
	currentViewTag = tag;
	
	NSRect newFrame = [self newFrameForNewContentView:view];
	
	// Using an animation grouping because we may be changing the duration
	[NSAnimationContext beginGrouping];
	
	// With the shift key down, do slow-mo animation
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
	    [[NSAnimationContext currentContext] setDuration:1.0];
	
	
	// Call the animator instead of the view / window directly
	[[[[self window] contentView] animator] replaceSubview:previousView with:view];
	[[[self window] animator] setFrame:newFrame display:YES];
	[NSAnimationContext endGrouping];

}
-(IBAction)checkForUpdates:(id)sender{
	[[NSApp delegate] performSelector:@selector(checkForUpdates:) withObject:self];
}
-(IBAction)openIUseThis:(id)sender{
	NSWorkspace * ws = [NSWorkspace sharedWorkspace];
	[ws openURL: [NSURL URLWithString: @"http://osx.iusethis.com/app/tototl/"]];

}
-(IBAction)openDonate:(id)sender{
	NSWorkspace * ws = [NSWorkspace sharedWorkspace];
	[ws openURL: [NSURL URLWithString: @"http://www.dreamhost.com/donate.cgi?id=10693"]];
}
-(IBAction)setProfile:(id)sender{

//	[[segmentedControl selectedSegment] tag];
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	NSString *location = [defaults objectForKey:@"location"];
	if(location)
		[twitterEngine setLocation:location];
	
	NSLog(@"method %@", deliveryMethod);
	if(deliveryMethod)
		[twitterEngine setNotificationsDeliveryMethod:deliveryMethod];
	
	[defaults setObject:deliveryMethod forKey:@"deliveryMethod"];
	[defaults synchronize];
}
-(IBAction)resetDefaults:(id)sender{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:nil forKey:@"backgroundColor"];
	[defaults setObject:nil forKey:@"borderColor"];
	[defaults setObject:nil forKey:@"fontColor"];
	[defaults setObject:nil forKey:@"rowHeight"];
	[defaults setObject:nil forKey:@"fontSize"];

//	[defaults setObject:[NSNumber numberWithInt:37] forKey:@"rowHeight"];
//	[defaults setObject:[NSNumber numberWithInt:12] forKey:@"fontSize"];
	[defaults synchronize];
}

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar;
{
	NSLog(@"items: %@", [toolbar items]);
    // Optional delegate method: Returns the identifiers of the subset of
    // toolbar items that are selectable. In our case, all of them
    return [toolbar items];
}
@end
