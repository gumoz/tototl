//
//  NSApplicationExtension.h
//  BSHotKey
//
//  Created by Karsten Kusche on 06.04.07.
//  Copyright 2007 briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface NSApplication (BSHotKeyExtension)

// event handlers called by sendEvent:
- (void)pressedHotKey:(EventHotKeyRef)hotKeyRef;
- (void)releasedHotKey:(EventHotKeyRef)hotKeyRef;

@end
