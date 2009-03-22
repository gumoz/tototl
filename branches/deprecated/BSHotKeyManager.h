//
//  BSHotKeyManager.h
//  BSHotKey
//
//  Created by Karsten Kusche on 06.04.07.
//  Copyright 2007 briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BSHotKey.h"

/*

 The HotKey manager is used to manage ONE!! hotkey.
 set the hotkey name, target and actions and it is ready to go.
 
 Usage:
 // to register the hotkey and to setup everything

 [[BSHotKeyManager defaultManager] hotKeyNamed: @"MyFirstHotkey" 
                                    withAction: @selector(hotkeyWasPressed:) 
										target: anObject
 //             /* optional *//*       default: [BSHotKey hotkeyWithCharacters:@"1" modifiers:NSCommandKeyMask | NSAlternateKeyMask]
 ];
 
 to configure the managed hotkey, add the prefsview in a custom interface like this:

 [myView addSubview: [[BSHotKeyManager defaultManager] prefsView]];
 
 the prefsView will have a size of 277x35 pixel
  
 the hotkey will automatically stored to the userdefaults whenever it is changed
 
 */

@interface BSHotKeyManager : NSObject {
	BSHotKey* hotKey;  // the represented hotkey
	NSString* name; // name of that hotkey for storing in userdefaults
	IBOutlet NSView* prefsView; // prefsview (277x35 pixel large)
	IBOutlet NSTextField* hotKeyString; // textview showing the hotkey
	EventHotKeyRef hotKeyRef; // hotkey reference that is used to identify the hotkey
	SEL action; // selector sent on pressed
	SEL releaseAction; // selector sent on released
	id target; // target that receives the selectors
	
	id prefsDelegate; // receives a hotKeyChangedTo: message if it implements it
}

// only use one manager
+ (id)defaultManager;

// [un]register the managed hotkey
- (void)registerHotKey;
- (void)unRegisterHotKey;

// initialize the hotkey
- (void)hotKeyNamed:(NSString*)hotKeyName withAction:(SEL)aSelector target:(id)aTarget; // selector sent on pressed
- (void)hotKeyNamed:(NSString*)hotKeyName withAction:(SEL)aSelector target:(id)aTarget default:(BSHotKey*)hotkey; // selector sent on pressed
- (void)setReleaseAction:(SEL)aSelector; // selector sent on released

// action invoked when change key button is pressed
- (IBAction)changeHotKey:(id)sender;

// eventhandlers sent by NSApp
- (void)hotKeyPressed:(EventHotKeyRef)keyRef;
- (void)hotKeyReleased:(EventHotKeyRef)keyRef;

// the prefs view to be used in a preference window
- (NSView*)prefsView;
- (BOOL)gotHotKey;
- (void)setHotKeyString;

- (void)setPrefsDelegate:(id)delegate;
- (id)prefsDelegate;
@end
