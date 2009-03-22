//
//  BSHotKey.h
//  GameTest
//
//  Created by Karsten Kusche on 08.11.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//
#ifndef __HOTKEY_H_KK__
#define __HOTKEY_H_KK__

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

/*
 
 This class represents a hotkey. 
 a hotkey can be registered, unregistered, printed and stored

*/

@interface BSHotKey : NSObject {
	unsigned char charCode;  // ascii code
	unsigned char keyCode;   // number of keyboard key
	unsigned short modifiers;// modifiers
	EventHotKeyID hotKeyID;  // id for registering
	EventHotKeyRef hotKeyRef; // reference used to identify the hotkey
}

// instance creation
+ (id)fromEvent:(EventRecord)theEvent;
+ (id)hotKeyFromArray:(NSArray*)array;

+ (id)hotKeyWithKey:(unsigned char)key charCode:(unsigned char)aChar modifiers: (int)modifiers;
// To use hotKeyWithKey:charChode:modifiers: please run the test app that is included 
// in the BSHotKey distribution. it will show which values to use as soon as the  hotkey is set


// [un]register a hotkey
- (EventHotKeyRef)setWithID:(unsigned int)anID;
- (void)unRegister;
// conversion and comparing
- (NSArray*) asArray;
- (BOOL)isEscapeHotKey;

@end

#endif
