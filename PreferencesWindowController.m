//
//  PreferencesWindowController.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 3/15/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

-(id)init {
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    return self;
}

- (void)awakeFromNib{
    [[self window] setContentSize:[twitterView frame].size];
    [[[self window] contentView] addSubview:twitterView];
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
		case 0: view = twitterView; break;
		case 1: default: view = tototlView; break;
		case 2: view = aboutView; break;
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
@end
